---
name: content-formats
description: Content format specifications and standards
---

# Content Formats Rule

## Purpose

Define consistent formats for all content types to ensure quality, accessibility, and maintainability.

## Document Formats

### Articles

**Structure:**
```markdown
# Title

## Introduction
- Hook/attention grabber
- Context/background
- What reader will learn

## Main Content
### Section 1
### Section 2
### Section 3

## Conclusion
- Summary of key points
- Call to action
- Next steps

## References
- Citations
- Further reading
```

**Length Guidelines:**
- Short form: 500-1000 words
- Standard: 1000-2500 words
- Long form: 2500+ words

**Use Cases:**
- Blog posts
- Tutorial articles
- Announcements
- Opinion pieces

### Tutorials

**Structure:**
```markdown
# Tutorial: [Task]

## Prerequisites
- Required knowledge
- Required tools
- Time estimate

## Learning Objectives
- By the end, you will be able to...

## Step 1: [Action]
Explanation of what and why.

```code
# Example code
```

Expected result.

## Step 2: [Action]
...

## Complete Example
Full working code.

## Troubleshooting
Common issues and solutions.

## Next Steps
Where to go from here.
```

**Requirements:**
- All code tested
- Screenshots where helpful
- Troubleshooting section
- Complete example provided

### Reference Documentation

**Structure:**
```markdown
# [Component] Reference

## Overview
Brief description and purpose.

## Syntax
```
function_name(parameter1, parameter2)
```

## Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| param1 | string | Yes | Description |

## Return Value
Description of return value.

## Examples

### Basic Usage
```code
# Simple example
```

### Advanced Usage
```code
# Complex example
```

## Related
- [Link to related docs]
- [Link to tutorial]

## Changelog
- Version changes
```

**Requirements:**
- Complete parameter list
- All edge cases documented
- Multiple examples
- Version information

### API Documentation

**Structure:**
```markdown
# [Endpoint]

## [METHOD] /path

### Description
What this endpoint does.

### Authentication
Required auth method.

### Request

#### Headers
| Name | Value | Required |
|------|-------|----------|
| Content-Type | application/json | Yes |

#### Body
```json
{
  "field": "value"
}
```

### Response

#### Success (200)
```json
{
  "data": {}
}
```

#### Errors
| Code | Description |
|------|-------------|
| 400 | Invalid input |
| 401 | Unauthorized |

### Rate Limiting
Requests per minute/hour.

### Examples
```bash
curl -X POST ...
```
```

## Media Formats

### Images

**Specifications:**
- Format: PNG for diagrams, JPEG for photos
- Max width: 1200px
- Compression: Optimized for web
- Alt text: Required

**Types:**
- Screenshots: Annotated with arrows/boxes
- Diagrams: Consistent style, readable fonts
- Photos: High quality, relevant

**File Naming:**
```
[tutorial-slug]-[description]-[sequence].png
example: auth-flow-diagram-01.png
```

### Videos

**Specifications:**
- Format: MP4 (H.264)
- Resolution: 1080p minimum
- Length: Keep under 10 minutes
- Captions: Required

**Structure:**
- Introduction (what we'll cover)
- Main content (step by step)
- Summary (recap)

**Accessibility:**
- Closed captions
- Transcript provided
- Audio description if needed

### Code Blocks

**Formatting:**
````markdown
```language
# Code with syntax highlighting
def example():
    return "highlighted"
```
````

**Requirements:**
- Language specified
- Syntax highlighting enabled
- Line numbers for long blocks
- Copy button (if platform supports)

**Annotations:**
```markdown
```python
def process_data(data):
    # (1) Validate input
    if not data:
        raise ValueError("Data required")
    
    # (2) Process
    result = transform(data)
    
    return result
```

1. Input validation prevents errors
2. Transform applies business logic
```
```

## Template Files

### Chapter Template
Location: `content-templates/chapter.md`

### Lesson Template
Location: `content-templates/lesson.md`

### Article Template
Location: `content-templates/article.md`

### Document Template
Location: `content-templates/document.md`

### Transcript Template
Location: `content-templates/transcript.md`

## Metadata Standards

### Frontmatter

```yaml
---
title: "Document Title"
description: "Brief description for SEO"
author: "Author Name"
date: "2024-01-15"
updated: "2024-01-20"
tags:
  - topic1
  - topic2
category: "Category Name"
readingTime: "5 min"
version: "1.0"
---
```

### Required Fields
- `title` - Document title
- `description` - SEO description
- `author` - Content author
- `date` - Publication date

### Optional Fields
- `updated` - Last update date
- `tags` - Topic tags
- `category` - Content category
- `readingTime` - Estimated reading time
- `version` - Content version

## Accessibility Standards

### Text Content
- Reading level appropriate for audience
- Define technical terms on first use
- Use clear, concise language
- Avoid idioms and cultural references

### Visual Content
- Alt text for all images
- Descriptive link text
- Sufficient color contrast
- Don't rely on color alone

### Interactive Content
- Keyboard accessible
- Focus indicators visible
- Time limits can be extended
- Error messages clear
