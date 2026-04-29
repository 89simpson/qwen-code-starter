---
name: content-index
description: Content organization, categorization, and indexing
---

# Content Index Skill

## Purpose

Organize content for easy discovery, navigation, and maintenance through systematic indexing and categorization.

## When to Use

- When adding new content
- When content grows significantly
- When users report finding issues
- During content audits
- When restructuring

## Index Types

### Table of Contents

**Purpose:** Navigate single document

**Format:**
```markdown
## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Advanced Usage](#advanced-usage)
4. [FAQ](#faq)
```

### Site Map

**Purpose:** Navigate entire site

**Format:**
```markdown
# Documentation

## Getting Started
- [Installation](/docs/install)
- [Quick Start](/docs/quickstart)
- [Configuration](/docs/config)

## Guides
- [Tutorial 1](/docs/tutorial-1)
- [Tutorial 2](/docs/tutorial-2)

## Reference
- [API Reference](/docs/api)
- [Configuration Reference](/docs/config-ref)
```

### Search Index

**Purpose:** Enable content search

**Elements:**
- Title
- Content body
- Tags
- Categories
- Metadata

### Tag Index

**Purpose:** Browse by topic

**Format:**
```markdown
# Tags

## authentication
- [Auth Guide](/docs/auth)
- [OAuth Setup](/docs/oauth)

## api
- [API Reference](/docs/api)
- [REST Tutorial](/docs/rest)
```

## Organization Strategies

### Hierarchical

**Structure:**
```
Home
├── Getting Started
│   ├── Installation
│   ├── Quick Start
│   └── Configuration
├── Guides
│   ├── Tutorial 1
│   ├── Tutorial 2
│   └── Tutorial 3
└── Reference
    ├── API
    ├── Config
    └── FAQ
```

**Best For:**
- Large documentation sets
- Clear topic categories
- Progressive learning paths

### Tag-Based

**Structure:**
```
Content tagged with "authentication":
- Login Guide
- OAuth Setup
- Session Management
- Security Best Practices
```

**Best For:**
- Cross-cutting topics
- Flexible browsing
- Large content sets

### Hybrid

**Structure:**
```
Primary: Hierarchical categories
Secondary: Tags for cross-reference
```

**Best For:**
- Most documentation sites
- Complex content relationships

## Metadata Standards

### Required Metadata

```yaml
---
title: "Page Title"
description: "SEO description"
category: "Category Name"
tags:
  - tag1
  - tag2
author: "Author Name"
date: "2024-01-15"
---
```

### Optional Metadata

```yaml
---
updated: "2024-01-20"
version: "1.0"
readingTime: "5 min"
difficulty: "beginner"
prerequisites:
  - "Previous article"
related:
  - "Related article 1"
  - "Related article 2"
---
```

## Navigation Design

### Primary Navigation

**Top-Level Categories:**
- Getting Started
- Guides/Tutorials
- Reference
- API
- FAQ/Support

**Principles:**
- 5-7 items max
- Clear labels
- Logical grouping
- Consistent order

### Secondary Navigation

**Within Categories:**
- Chronological (for tutorials)
- Alphabetical (for reference)
- Complexity-based (beginner to advanced)

### Breadcrumbs

**Format:**
```
Home > Guides > Authentication > OAuth Setup
```

**Benefits:**
- Shows location
- Easy navigation
- SEO benefit

## Link Strategy

### Internal Links

**Types:**
- Navigation links (menu)
- Contextual links (in content)
- Related content links
- Next/previous links

**Best Practices:**
- Descriptive link text
- Relevant destinations
- Not too many per page
- Check for broken links

### External Links

**When to Link:**
- Official documentation
- Authoritative sources
- Tools and libraries
- Further reading

**Best Practices:**
- Open in new tab
- Indicate external
- Verify regularly
- Use archive links for volatile content

## Search Optimization

### Content for Search

**Include:**
- Clear headings
- Descriptive titles
- Relevant keywords
- Complete content

**Avoid:**
- Keyword stuffing
- Hidden text
- Duplicate content

### Search Index Fields

```yaml
searchable_fields:
  - title
  - headings
  - body_content
  - code_comments
  - alt_text
```

## Maintenance

### Regular Tasks

**Weekly:**
- Check for broken links
- Review new content categorization

**Monthly:**
- Update tag index
- Review search analytics
- Fix navigation issues

**Quarterly:**
- Full content audit
- Restructure if needed
- Update metadata

### Content Audit

**Checklist:**
- [ ] All content categorized
- [ ] Tags applied consistently
- [ ] Navigation working
- [ ] Search returning results
- [ ] No orphaned content
- [ ] Metadata complete

## Tools

### Static Site Generators

- Docusaurus
- MkDocs
- Hugo
- Jekyll
- Next.js

### Search Solutions

- Algolia DocSearch
- ElasticSearch
- Lunr.js
- Built-in CMS search

### Analytics

- Google Analytics
- Search query logs
- Click tracking
- Heat maps
