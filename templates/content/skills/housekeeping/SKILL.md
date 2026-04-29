---
name: housekeeping
description: Content maintenance and cleanup procedures
---

# Housekeeping Skill (Content)

## Purpose

Maintain content quality and accuracy through regular maintenance, updates, and cleanup activities.

## When to Use

- Scheduled maintenance windows
- After product updates
- When users report issues
- During content audits
- Before major releases

## Maintenance Tasks

### Link Maintenance

**Check For:**
- Broken external links
- Broken internal links
- Redirected URLs
- Outdated destinations

**Frequency:** Monthly

**Tools:**
```bash
# Check all links
lychee content/

# Continuous monitoring
github.com/lycheeverse/lychee
```

**Actions:**
- Fix broken links
- Update redirected URLs
- Remove dead links
- Document changes

### Content Updates

**Triggers:**
- Product version updates
- API changes
- Feature deprecations
- Best practice changes

**Frequency:** As needed (monitor releases)

**Actions:**
- Update version numbers
- Update screenshots
- Update code examples
- Add migration notes

### Accuracy Reviews

**Check For:**
- Outdated information
- Deprecated features
- Changed processes
- Incorrect claims

**Frequency:** Quarterly

**Actions:**
- Verify all technical claims
- Test all examples
- Update statistics
- Refresh content

### SEO Maintenance

**Check For:**
- Missing meta descriptions
- Poor titles
- Missing alt text
- Slow page loads

**Frequency:** Monthly

**Actions:**
- Add missing metadata
- Optimize titles
- Add alt text
- Compress images

## Cleanup Tasks

### Remove Orphaned Content

**Identify:**
- Pages with no incoming links
- Unused media files
- Draft content never published
- Deprecated content

**Actions:**
- Add navigation links
- Delete unused files
- Publish or remove drafts
- Archive or redirect deprecated

### Fix Formatting

**Check For:**
- Inconsistent heading styles
- Broken formatting
- Missing code highlighting
- Table formatting issues

**Actions:**
- Standardize headings
- Fix broken formatting
- Add syntax highlighting
- Fix table markup

### Remove Redundancy

**Identify:**
- Duplicate content
- Overlapping articles
- Conflicting information
- Unnecessary repetition

**Actions:**
- Merge duplicates
- Clarify article purposes
- Resolve conflicts
- Remove redundancy

## Update Procedures

### Version Updates

**When Product Updates:**
```markdown
1. Identify affected content
2. Update version numbers
3. Test all examples
4. Update screenshots
5. Add changelog entry
6. Note breaking changes
```

**Documentation:**
```markdown
## Updated for v2.0

Changes in this update:
- Updated all version references to 2.0
- Updated API examples
- Added migration notes
- New screenshots
```

### API Changes

**When API Updates:**
```markdown
1. Review API changelog
2. Identify affected docs
3. Update examples
4. Add deprecation notices
5. Create migration guide
6. Set sunset date for old docs
```

### Content Refresh

**For Aging Content:**
```markdown
1. Review analytics
2. Check user feedback
3. Update examples
4. Refresh introduction
5. Add new sections
6. Update "last updated" date
```

## Audit Process

### Content Audit

**Scope:** All content

**Checklist:**
```markdown
## Content Audit Checklist

### Accuracy
- [ ] Version numbers current
- [ ] Examples working
- [ ] Claims verified
- [ ] No deprecated features

### Completeness
- [ ] All features documented
- [ ] No gaps in coverage
- [ ] Prerequisites stated
- [ ] Next steps clear

### Quality
- [ ] No spelling errors
- [ ] Grammar correct
- [ ] Consistent style
- [ ] Clear writing

### Navigation
- [ ] All pages reachable
- [ ] Breadcrumbs correct
- [ ] Search working
- [ ] No orphaned pages
```

### Priority Matrix

| Impact | Urgent | Scheduled |
|--------|--------|-----------|
| High | Fix immediately | Plan this sprint |
| Medium | Fix this week | Plan this month |
| Low | Fix this month | Backlog |

## Automation

### Automated Checks

**CI/CD Integration:**
```yaml
# GitHub Actions
name: Content Checks

on: [push, pull_request]

jobs:
  links:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check links
        run: lychee content/
  
  spelling:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check spelling
        run: cspell content/**/*.md
```

### Scheduled Tasks

**Cron Jobs:**
```bash
# Weekly link check
0 0 * * 0 /path/to/check-links.sh

# Monthly audit report
0 0 1 * * /path/to/content-audit.sh
```

## Documentation

### Maintenance Log

```markdown
# Maintenance Log

## 2024-01-15
- Updated all Python examples to 3.12
- Fixed 12 broken external links
- Added alt text to 8 images

## 2024-01-01
- Quarterly content audit complete
- Archived 3 deprecated articles
- Updated version references
```

### Change Tracking

```markdown
## Content Changes

### Modified
- [file1.md](link) - Updated examples
- [file2.md](link) - Fixed typos

### Added
- [new-article.md](link) - New tutorial

### Removed
- [deprecated.md](link) - Redirected to [new.md](link)
```

## Metrics

### Maintenance Metrics

**Track:**
- Broken links found/fixed
- Content updates made
- Audit issues resolved
- Time spent on maintenance

### Quality Metrics

**Track:**
- Content accuracy score
- Link health percentage
- Update frequency
- User satisfaction
