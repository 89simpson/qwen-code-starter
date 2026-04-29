---
name: content-commit-policy
description: Version control practices for content projects
---

# Content Commit Policy Rule

## Purpose

Establish consistent version control practices for content to enable tracking, collaboration, and maintenance.

## Commit Structure

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Content-Specific Types

| Type | Description | Example |
|------|-------------|---------|
| `content` | New content added | `content(api): Add authentication guide` |
| `update` | Existing content updated | `update(tutorials): Refresh Python examples` |
| `fix` | Corrections made | `fix(docs): Correct API endpoint URL` |
| `refactor` | Content reorganized | `refactor(structure): Move guides to tutorials` |
| `meta` | Metadata changes | `meta(seo): Add descriptions to all pages` |
| `media` | Images/media changes | `media(images): Add screenshots to setup guide` |
| `links` | Link updates | `fix(links): Update broken external links` |

### Subject Line Rules

- Maximum 50 characters
- Start with capital letter
- No period at end
- Use imperative mood

**Examples:**
```
content(api): Add rate limiting documentation
update(examples): Upgrade to Python 3.12 syntax
fix(typo): Correct function name in quickstart
```

## Commit Size

### Ideal Content Commit

- Single topic or section
- 1-5 files changed
- Clear, reviewable change
- Can be reverted independently

### When to Split Commits

**Split by:**
- Different sections
- Content vs. formatting
- Text vs. media
- Substantive vs. typo fixes

**Example:**
```
# Bad: One giant commit
- Add new tutorial
- Fix typos in existing docs
- Update all screenshots
- Reorganize navigation

# Good: Separate commits
content(tutorials): Add async/await tutorial
fix(typos): Correct errors in getting started
media(screenshots): Update UI screenshots
refactor(nav): Reorganize documentation structure
```

## Branch Strategy

### Branch Naming

```
content/<topic>
update/<section>
fix/<issue>
```

**Examples:**
```
content/api-authentication
update/python-examples
fix/broken-links
```

### Workflow

```
main (production-ready content)
  ↑
staging (review queue)
  ↑
content/* (work in progress)
```

## Pre-Commit Checklist

### Content Quality
- [ ] Spell check complete
- [ ] Grammar checked
- [ ] Links verified
- [ ] Code examples tested
- [ ] Images optimized

### Technical
- [ ] Build succeeds
- [ ] No broken links
- [ ] Metadata complete
- [ ] Accessibility checked

### Documentation
- [ ] Changelog updated
- [ ] Version bumped (if needed)
- [ ] Commit message clear

## Review Process

### Self-Review

Before submitting:
```
□ Read content aloud
□ Check all links
□ Test all examples
□ Verify build
□ Check mobile rendering
```

### Peer Review

For technical content:
```
□ Technical accuracy verified
□ Examples tested
□ No gaps in explanation
□ Appropriate level
```

### Editorial Review

For all content:
```
□ Style guide followed
□ Grammar correct
□ Clear and concise
□ Consistent tone
```

## Version Management

### Content Versioning

**When to Version:**
- Major content rewrites
- API version changes
- Breaking changes in examples
- Significant updates

**Version Format:**
```
major.minor.patch
- major: Breaking changes
- minor: New content/features
- patch: Corrections, small updates
```

### Changelog

**Format:**
```markdown
# Changelog

## [1.2.0] - 2024-01-15

### Added
- New authentication guide
- API rate limiting documentation

### Changed
- Updated Python examples to 3.12
- Refreshed screenshots

### Fixed
- Corrected endpoint URLs
- Fixed broken internal links

### Removed
- Deprecated API v1 documentation
```

## File Organization

### Directory Structure

```
content/
├── articles/
│   ├── 2024-01-article-title.md
│   └── 2024-02-another-article.md
├── tutorials/
│   ├── getting-started/
│   │   ├── index.md
│   │   └── step-1.md
│   └── advanced/
├── reference/
│   ├── api/
│   └── configuration/
└── media/
    ├── images/
    └── videos/
```

### File Naming

**Articles:**
```
YYYY-MM-short-title.md
2024-01-authentication-guide.md
```

**Tutorials:**
```
tutorial-topic.md
tutorial-api-basics.md
```

**Reference:**
```
ref-component-name.md
ref-api-users.md
```

## Collaboration

### Concurrent Editing

**Avoid Conflicts:**
- Communicate editing plans
- Work on different sections
- Merge frequently
- Use draft branches

**Resolve Conflicts:**
- Compare both versions
- Preserve both contributions
- Maintain consistency
- Test after merge

### Review Comments

**In PR/MR:**
- Use inline comments
- Be specific and constructive
- Suggest improvements
- Approve when ready

**Response:**
- Address all comments
- Explain decisions
- Update content
- Request re-review

## Publishing Workflow

### Pre-Publish

```bash
# 1. Final review
git diff main

# 2. Build check
npm run build

# 3. Link check
npm run check-links

# 4. Create PR
git push origin content/new-guide
```

### Post-Publish

```bash
# 1. Verify on production
# 2. Check analytics
# 3. Monitor feedback
# 4. Plan updates
```

## Maintenance Commits

### Regular Updates

**Monthly:**
- Fix broken links
- Update screenshots
- Correct typos

```
fix(links): Update broken external links
media(screenshots): Refresh UI images
fix(typos): Correct errors in FAQ
```

**Quarterly:**
- Content audit
- Update examples
- Refresh statistics

```
update(examples): Upgrade to latest versions
content(stats): Refresh 2024 statistics
```

### Deprecation

**When Content is Outdated:**
```
1. Add deprecation notice
2. Link to current version
3. Keep for historical reference
4. Document in changelog
```

**Commit:**
```
meta(deprecate): Mark v1 API docs as deprecated

Added deprecation notice with link to v2 docs.
Keeping for historical reference.
```

## Automation

### Pre-commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Spell check
npm run spellcheck

# Link check
npm run check-links

# Build check
npm run build

# If any fail, commit is rejected
```

### CI/CD Checks

```yaml
# GitHub Actions
name: Content Checks

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: npm run build
      - name: Check links
        run: npm run check-links
      - name: Check spelling
        run: npm run spellcheck
```
