#!/usr/bin/env python3
"""
Tests for merge_qwen_md.py utility

Run with: python -m pytest tests/test-merge-qwen-md.py -v
Or: python tests/test-merge-qwen-md.py
"""

import os
import sys
import tempfile
import unittest
from pathlib import Path

# Add scripts/lib to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts" / "lib"))

from merge_qwen_md import (
    parse_frontmatter,
    parse_sections,
    merge_frontmatter,
    merge_sections,
    format_frontmatter,
    format_sections,
    merge_qwen_md,
)


class TestParseFrontmatter(unittest.TestCase):
    """Test frontmatter parsing."""

    def test_parse_simple_frontmatter(self):
        content = """---
name: test-project
type: code
---

# Body
"""
        fm, body = parse_frontmatter(content)
        self.assertEqual(fm["name"], "test-project")
        self.assertEqual(fm["type"], "code")
        self.assertIn("# Body", body)

    def test_parse_empty_frontmatter(self):
        content = """---
---

# Body
"""
        fm, body = parse_frontmatter(content)
        self.assertEqual(fm, {})
        self.assertIn("# Body", body)

    def test_parse_no_frontmatter(self):
        content = "# Just body"
        fm, body = parse_frontmatter(content)
        self.assertEqual(fm, {})
        self.assertEqual(body, "# Just body")

    def test_parse_multiline_values(self):
        content = """---
name: test
description: A test project
with multiple lines
---

# Body
"""
        fm, body = parse_frontmatter(content)
        self.assertEqual(fm["name"], "test")


class TestParseSections(unittest.TestCase):
    """Test section parsing."""

    def test_parse_single_section(self):
        content = """## Section One

Content here.
"""
        sections = parse_sections(content)
        self.assertIn("section-one", sections)
        self.assertIn("Content here", sections["section-one"])

    def test_parse_multiple_sections(self):
        content = """## Section One

Content 1.

## Section Two

Content 2.
"""
        sections = parse_sections(content)
        self.assertIn("section-one", sections)
        self.assertIn("section-two", sections)

    def test_parse_with_preamble(self):
        content = """Intro text.

## Section One

Content.
"""
        sections = parse_sections(content)
        self.assertIn("preamble", sections)
        self.assertIn("section-one", sections)


class TestMergeFrontmatter(unittest.TestCase):
    """Test frontmatter merging."""

    def test_existing_takes_precedence(self):
        template_fm = {"name": "template", "version": "1.0"}
        existing_fm = {"name": "existing", "author": "John"}

        merged = merge_frontmatter(template_fm, existing_fm)

        self.assertEqual(merged["name"], "existing")  # Existing wins
        self.assertEqual(merged["version"], "1.0")  # From template
        self.assertEqual(merged["author"], "John")  # From existing

    def test_template_fields_preserved(self):
        template_fm = {"framework-version": "1.0"}
        existing_fm = {"name": "project"}

        merged = merge_frontmatter(template_fm, existing_fm)

        self.assertEqual(merged["framework-version"], "1.0")

    def test_merge_empty_existing(self):
        template_fm = {"name": "template", "version": "1.0"}
        existing_fm = {}

        merged = merge_frontmatter(template_fm, existing_fm)

        self.assertEqual(merged["name"], "template")
        self.assertEqual(merged["version"], "1.0")


class TestMergeSections(unittest.TestCase):
    """Test section merging."""

    def test_smart_strategy_framework_sections(self):
        template_sections = {"development-practices": "template content"}
        existing_sections = {"project-overview": "existing content"}

        merged = merge_sections(template_sections, existing_sections, "smart")

        # Framework sections from template
        self.assertEqual(merged["development-practices"], "template content")
        # Existing sections preserved
        self.assertEqual(merged["project-overview"], "existing content")

    def test_template_wins_strategy(self):
        template_sections = {"section": "template"}
        existing_sections = {"section": "existing"}

        merged = merge_sections(template_sections, existing_sections, "template-wins")

        self.assertEqual(merged["section"], "template")

    def test_existing_wins_strategy(self):
        template_sections = {"section": "template"}
        existing_sections = {"section": "existing"}

        merged = merge_sections(template_sections, existing_sections, "existing-wins")

        self.assertEqual(merged["section"], "existing")


class TestFormatFrontmatter(unittest.TestCase):
    """Test frontmatter formatting."""

    def test_format_simple_frontmatter(self):
        fm = {"name": "test", "type": "code"}
        formatted = format_frontmatter(fm)

        self.assertIn("---", formatted)
        self.assertIn("name: test", formatted)
        self.assertIn("type: code", formatted)

    def test_format_empty_frontmatter(self):
        fm = {}
        formatted = format_frontmatter(fm)
        self.assertEqual(formatted, "")


class TestFormatSections(unittest.TestCase):
    """Test section formatting."""

    def test_format_sections(self):
        sections = {"section-one": "## Section One\n\nContent"}
        formatted = format_sections(sections)

        self.assertIn("## Section One", formatted)
        self.assertIn("Content", formatted)


class TestMergeQwenMd(unittest.TestCase):
    """Test full merge workflow."""

    def setUp(self):
        """Create temporary files for testing."""
        self.temp_dir = tempfile.mkdtemp()

    def tearDown(self):
        """Clean up temporary files."""
        import shutil
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_merge_files(self):
        template_path = os.path.join(self.temp_dir, "template.md")
        existing_path = os.path.join(self.temp_dir, "existing.md")
        output_path = os.path.join(self.temp_dir, "output.md")

        # Create template
        template_content = """---
name: template
framework-version: 1.0
---

## Development Practices

Template practices.

## Project Overview

Template overview.
"""
        with open(template_path, "w") as f:
            f.write(template_content)

        # Create existing
        existing_content = """---
name: existing
author: John
---

## Project Overview

Existing overview.

## Goals

Existing goals.
"""
        with open(existing_path, "w") as f:
            f.write(existing_content)

        # Merge
        success = merge_qwen_md(
            template_path, existing_path, output_path, strategy="smart"
        )

        self.assertTrue(success)
        self.assertTrue(os.path.exists(output_path))

        # Verify output
        with open(output_path, "r") as f:
            output = f.read()

        # Check that existing name is preserved
        self.assertIn("name: existing", output)
        # Check that framework version is from template
        self.assertIn("framework-version: 1.0", output)
        # Check that development practices from template
        self.assertIn("Template practices", output)
        # Check that goals from existing
        self.assertIn("Existing goals", output)

    def test_dry_run(self):
        template_path = os.path.join(self.temp_dir, "template.md")
        existing_path = os.path.join(self.temp_dir, "existing.md")

        with open(template_path, "w") as f:
            f.write("---\nname: test\n---\n\n## Section\n\nContent")
        with open(existing_path, "w") as f:
            f.write("---\nname: existing\n---\n\n## Section\n\nExisting")

        # Should not create output file
        output_path = os.path.join(self.temp_dir, "output.md")
        success = merge_qwen_md(
            template_path, existing_path, output_path, dry_run=True
        )

        self.assertTrue(success)
        self.assertFalse(os.path.exists(output_path))


class TestEdgeCases(unittest.TestCase):
    """Test edge cases and error handling."""

    def test_missing_file(self):
        success = merge_qwen_md(
            "/nonexistent/template.md",
            "/nonexistent/existing.md",
        )
        self.assertFalse(success)

    def test_special_characters_in_content(self):
        fm, body = parse_frontmatter("""---
name: test-project
description: "Test with 'quotes' and <tags>"
---

# Body with `code` and *markdown*
""")
        self.assertEqual(fm["name"], "test-project")
        self.assertIn("quotes", fm["description"])


def run_tests():
    """Run all tests."""
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()

    # Add all test classes
    suite.addTests(loader.loadTestsFromTestCase(TestParseFrontmatter))
    suite.addTests(loader.loadTestsFromTestCase(TestParseSections))
    suite.addTests(loader.loadTestsFromTestCase(TestMergeFrontmatter))
    suite.addTests(loader.loadTestsFromTestCase(TestMergeSections))
    suite.addTests(loader.loadTestsFromTestCase(TestFormatFrontmatter))
    suite.addTests(loader.loadTestsFromTestCase(TestFormatSections))
    suite.addTests(loader.loadTestsFromTestCase(TestMergeQwenMd))
    suite.addTests(loader.loadTestsFromTestCase(TestEdgeCases))

    # Run tests
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Return exit code
    return 0 if result.wasSuccessful() else 1


if __name__ == "__main__":
    sys.exit(run_tests())
