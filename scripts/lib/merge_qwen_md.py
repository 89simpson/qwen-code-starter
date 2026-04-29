#!/usr/bin/env python3
"""
Qwen Code Starter - QWEN.md Merge Utility

Merges QWEN.md files from templates with existing project QWEN.md,
preserving custom sections while updating framework sections.

Usage:
    python merge_qwen_md.py [OPTIONS] TEMPLATE_QWEN.md EXISTING_QWEN.md [OUTPUT_QWEN.md]

Options:
    --dry-run       Show what would be merged without writing
    --verbose       Enable verbose output
    --strategy      Merge strategy: template-wins, existing-wins, smart (default: smart)
    --output, -o    Output file path (default: stdout)
    --help, -h      Show this help message
"""

import argparse
import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple


# Sections that are managed by the framework
FRAMEWORK_SECTIONS = [
    "development-practices",
    "project-constraints",
    "quality-standards",
    "testing-requirements",
    "security-guidelines",
    "performance-requirements",
    "documentation-standards",
    "code-review-process",
    "deployment-procedures",
    "monitoring-requirements",
]

# Sections that are always preserved from existing
PRESERVED_SECTIONS = [
    "project-overview",
    "goals",
    "tech-stack",
    "architecture",
    "database-schema",
    "api-endpoints",
    "environment-variables",
    "project-specific",
    "custom-section",
]


def parse_frontmatter(content: str) -> Tuple[Dict[str, str], str]:
    """
    Parse YAML frontmatter from markdown content.

    Returns:
        Tuple of (frontmatter_dict, body_content)
    """
    frontmatter = {}
    body = content

    # Match YAML frontmatter between --- delimiters
    frontmatter_match = re.match(r'^---\s*\n(.*?)\n---\s*\n(.*)', content, re.DOTALL)

    if frontmatter_match:
        fm_text = frontmatter_match.group(1)
        body = frontmatter_match.group(2)

        # Parse simple YAML key-value pairs
        for line in fm_text.strip().split('\n'):
            if ':' in line:
                key, value = line.split(':', 1)
                frontmatter[key.strip()] = value.strip()

    return frontmatter, body


def parse_sections(content: str) -> Dict[str, str]:
    """
    Parse markdown content into sections based on headers.

    Returns:
        Dict mapping section names to their content
    """
    sections = {}
    current_section = "preamble"
    current_content = []

    # Split by level-2 headers (##)
    lines = content.split('\n')

    for line in lines:
        header_match = re.match(r'^##\s+(.+)$', line)

        if header_match:
            # Save previous section
            if current_content:
                sections[current_section] = '\n'.join(current_content)

            # Start new section
            current_section = header_match.group(1).lower().strip()
            current_section = re.sub(r'[^a-z0-9-]', '-', current_section)
            current_content = [line]
        else:
            current_content.append(line)

    # Save last section
    if current_content:
        sections[current_section] = '\n'.join(current_content)

    return sections


def merge_frontmatter(template_fm: Dict[str, str], existing_fm: Dict[str, str]) -> Dict[str, str]:
    """
    Merge frontmatter from template and existing QWEN.md.

    Strategy:
    - Existing values take precedence for project-specific fields
    - Template values used for framework fields
    """
    merged = {}

    # Fields that should always come from template (framework defaults)
    template_fields = [
        "framework-version",
        "template-version",
    ]

    # Fields that should always come from existing (project-specific)
    existing_fields = [
        "name",
        "version",
        "last-updated",
        "author",
    ]

    # Copy template fields
    for field in template_fields:
        if field in template_fm:
            merged[field] = template_fm[field]

    # Copy existing fields
    for field in existing_fields:
        if field in existing_fm:
            merged[field] = existing_fm[field]

    # Merge remaining fields (existing takes precedence)
    all_fields = set(template_fm.keys()) | set(existing_fm.keys())
    for field in all_fields:
        if field not in merged:
            if field in existing_fm:
                merged[field] = existing_fm[field]
            elif field in template_fm:
                merged[field] = template_fm[field]

    return merged


def merge_sections(
    template_sections: Dict[str, str],
    existing_sections: Dict[str, str],
    strategy: str = "smart"
) -> Dict[str, str]:
    """
    Merge sections from template and existing QWEN.md.

    Strategies:
    - smart: Framework sections from template, project sections from existing
    - template-wins: All sections from template
    - existing-wins: All sections from existing
    """
    merged = {}

    if strategy == "template-wins":
        return template_sections
    elif strategy == "existing-wins":
        return existing_sections

    # Smart strategy
    # First, add all existing sections
    for section_name, content in existing_sections.items():
        merged[section_name] = content

    # Then, add/update framework sections from template
    for section_name, content in template_sections.items():
        normalized_name = section_name.lower().strip()
        normalized_name = re.sub(r'[^a-z0-9-]', '-', normalized_name)

        # Check if this is a framework-managed section
        is_framework = any(
            fw in normalized_name for fw in FRAMEWORK_SECTIONS
        )
        is_preserved = any(
            pres in normalized_name for pres in PRESERVED_SECTIONS
        )

        if is_framework and not is_preserved:
            # Use template version for framework sections
            merged[section_name] = content
        elif normalized_name not in merged:
            # Add new sections from template
            merged[section_name] = content

    return merged


def format_frontmatter(frontmatter: Dict[str, str]) -> str:
    """Format frontmatter as YAML."""
    if not frontmatter:
        return ""

    lines = ["---"]
    for key, value in frontmatter.items():
        lines.append(f"{key}: {value}")
    lines.append("---")
    lines.append("")

    return '\n'.join(lines)


def format_sections(sections: Dict[str, str]) -> str:
    """Format sections as markdown."""
    # Order sections logically
    section_order = [
        "preamble",
        "project-overview",
        "goals",
        "tech-stack",
        "architecture",
        "development-practices",
        "project-constraints",
        "quality-standards",
        "testing-requirements",
        "security-guidelines",
    ]

    ordered_content = []

    # Add ordered sections first
    for section_name in section_order:
        if section_name in sections:
            ordered_content.append(sections[section_name])

    # Add remaining sections
    added = set(section_order)
    for section_name, content in sections.items():
        if section_name not in added:
            ordered_content.append(content)

    return '\n\n'.join(ordered_content)


def merge_qwen_md(
    template_path: str,
    existing_path: str,
    output_path: Optional[str] = None,
    strategy: str = "smart",
    dry_run: bool = False,
    verbose: bool = False
) -> bool:
    """
    Merge QWEN.md files.

    Args:
        template_path: Path to template QWEN.md
        existing_path: Path to existing QWEN.md
        output_path: Path for merged output (None for stdout)
        strategy: Merge strategy
        dry_run: Show what would be done without writing
        verbose: Enable verbose output

    Returns:
        True if successful, False otherwise
    """
    # Read files
    try:
        template_content = Path(template_path).read_text()
        existing_content = Path(existing_path).read_text()
    except FileNotFoundError as e:
        print(f"Error: File not found: {e}", file=sys.stderr)
        return False
    except IOError as e:
        print(f"Error reading file: {e}", file=sys.stderr)
        return False

    if verbose:
        print(f"Template: {template_path}")
        print(f"Existing: {existing_path}")
        print(f"Strategy: {strategy}")
        print()

    # Parse frontmatter
    template_fm, template_body = parse_frontmatter(template_content)
    existing_fm, existing_body = parse_frontmatter(existing_content)

    if verbose:
        print(f"Template frontmatter keys: {list(template_fm.keys())}")
        print(f"Existing frontmatter keys: {list(existing_fm.keys())}")
        print()

    # Parse sections
    template_sections = parse_sections(template_body)
    existing_sections = parse_sections(existing_body)

    if verbose:
        print(f"Template sections: {list(template_sections.keys())}")
        print(f"Existing sections: {list(existing_sections.keys())}")
        print()

    # Merge
    merged_fm = merge_frontmatter(template_fm, existing_fm)
    merged_sections = merge_sections(template_sections, existing_sections, strategy)

    # Format output
    output_content = format_frontmatter(merged_fm)
    output_content += format_sections(merged_sections)

    # Output
    if dry_run:
        print("[DRY RUN] Would write merged content:")
        print("-" * 40)
        print(output_content[:500] + "..." if len(output_content) > 500 else output_content)
        print("-" * 40)
        print()
        print(f"Total length: {len(output_content)} characters")
        print(f"Frontmatter fields: {len(merged_fm)}")
        print(f"Sections: {len(merged_sections)}")
    elif output_path:
        try:
            Path(output_path).write_text(output_content)
            if verbose:
                print(f"Written to: {output_path}")
        except IOError as e:
            print(f"Error writing file: {e}", file=sys.stderr)
            return False
    else:
        print(output_content)

    return True


def main():
    parser = argparse.ArgumentParser(
        description="Merge QWEN.md files from templates with existing project files"
    )
    parser.add_argument(
        "template",
        help="Path to template QWEN.md"
    )
    parser.add_argument(
        "existing",
        help="Path to existing QWEN.md"
    )
    parser.add_argument(
        "output",
        nargs="?",
        default=None,
        help="Output file path (default: stdout)"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be merged without writing"
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose output"
    )
    parser.add_argument(
        "--strategy",
        choices=["template-wins", "existing-wins", "smart"],
        default="smart",
        help="Merge strategy (default: smart)"
    )
    parser.add_argument(
        "-o", "--output",
        dest="output_file",
        help="Output file path (alias)"
    )

    args = parser.parse_args()

    # Handle output path
    output_path = args.output_file or args.output

    success = merge_qwen_md(
        template_path=args.template,
        existing_path=args.existing,
        output_path=output_path,
        strategy=args.strategy,
        dry_run=args.dry_run,
        verbose=args.verbose
    )

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
