---
name: source-management
description: Source citation, verification, and reference management
---

# Source Management Rule

## Purpose

Ensure all content is properly sourced, verified, and referenced to maintain credibility and enable verification.

## Source Types

### Primary Sources

**Definition:** Original, first-hand information

**Examples:**
- Official documentation
- API specifications
- RFCs and standards
- Original research papers
- Direct interviews

**Priority:** Highest - always prefer primary sources

### Secondary Sources

**Definition:** Analysis or interpretation of primary sources

**Examples:**
- Technical blogs
- Tutorial articles
- Conference talks
- Books and ebooks
- Documentation guides

**Priority:** Good - verify against primary when possible

### Tertiary Sources

**Definition:** Collections or summaries of secondary sources

**Examples:**
- Wikipedia
- Aggregator sites
- Summary articles
- List posts

**Priority:** Use for discovery, verify with primary/secondary

## Citation Standards

### Citation Format

**In-Text Citations:**
```markdown
According to the official documentation [1], the function returns...

Research shows this approach is effective [2][3].
```

**Reference List:**
```markdown
## References

[1] Python Software Foundation. "requests library." 
    https://docs.python.org/3/library/requests.html
    
[2] Smith, J. "Best Practices for API Design." 
    Tech Blog, 2024. https://example.com/api-design
    
[3] Johnson, M. "RESTful API Guidelines." 
    Conference Talk, 2023. https://example.com/talk
```

### Required Information

**For Each Source:**
- Author/organization
- Title
- Publication date
- URL (if online)
- Access date (for volatile content)
- Version (if applicable)

### Citation Styles

**Technical Content:**
```
[Number] Author. "Title." Publication. Date. URL.
```

**Academic Content:**
```
APA: Author, A. (Date). Title. Publication. URL
MLA: Author. "Title." Publication, Date. URL
```

## Source Verification

### Verification Checklist

**Credibility:**
- [ ] Author is qualified
- [ ] Publication is reputable
- [ ] No obvious bias
- [ ] Peer-reviewed (if academic)

**Currency:**
- [ ] Publication date appropriate
- [ ] Information still current
- [ ] No superseded info
- [ ] Version matches our usage

**Accuracy:**
- [ ] Claims can be verified
- [ ] Data sources cited
- [ ] Methodology sound
- [ ] No factual errors

### Red Flags

**Avoid Sources With:**
- No author attribution
- No publication date
- Obvious factual errors
- Heavy bias without disclosure
- Outdated information
- No citations of their own

### Verification Process

```
1. Identify source type (primary/secondary/tertiary)
2. Check author credentials
3. Verify publication date
4. Cross-reference with other sources
5. Test any technical claims
6. Document verification results
```

## Source Organization

### Source Document Template

```markdown
# Sources: [Topic]

## Primary Sources
1. [Title](URL)
   - Author: [Name]
   - Date: [Date]
   - Key points: [Summary]
   - Verified: [Date] by [Who]

## Secondary Sources
1. [Title](URL)
   - Author: [Name]
   - Date: [Date]
   - Key points: [Summary]
   - Notes: [Any concerns]

## To Verify
- [ ] [Claim that needs verification]
- [ ] [Technical detail to test]
```

### Tagging System

**By Type:**
- `#primary` - Original source
- `#secondary` - Analysis/interpretation
- `#tertiary` - Summary/collection

**By Reliability:**
- `#verified` - Fully verified
- `#trusted` - From trusted source
- `#unverified` - Needs verification

**By Topic:**
- `#api` - API documentation
- `#security` - Security information
- `#performance` - Performance data

## Link Management

### Link Hygiene

**Best Practices:**
- Use permanent URLs when possible
- Avoid deep links that may break
- Prefer official domains
- Use archive links for volatile content

**Link Text:**
```markdown
Bad: Click here
Good: Python requests documentation
Better: The requests library handles authentication automatically
```

### Link Maintenance

**Regular Checks:**
- Monthly: Check all links
- Quarterly: Update outdated links
- Annually: Comprehensive audit

**Tools:**
```bash
# Check for broken links
lychee content/

# Continuous monitoring
github.com/lycheeverse/lychee
```

### Link Replacement

**When Source Moves:**
1. Try to find new location
2. Use Wayback Machine if needed
3. Update citation with note
4. Document the change

**When Source Disappears:**
1. Search for alternative sources
2. Use archived version
3. Note as unavailable
4. Consider removing claim if critical

## Attribution

### Direct Quotes

**Format:**
```markdown
> "Direct quote from source." 
> — Author, *Title* [citation]
```

**Guidelines:**
- Use sparingly
- Always cite
- Preserve original meaning
- Indicate any omissions [...]

### Paraphrasing

**Requirements:**
- Still cite the source
- Significantly reword
- Maintain original meaning
- Add your own analysis

### Code Examples

**From Sources:**
- Cite the source
- Note any modifications
- Verify still works
- Test independently

## Source Updates

### Monitoring

**Set Up Alerts:**
- Google Alerts for key topics
- RSS feeds for blogs
- GitHub watches for repos
- Newsletter subscriptions

### Update Triggers

**Update Content When:**
- Source is updated significantly
- New version released
- Security issues discovered
- Best practices change

### Version Tracking

**Document:**
```markdown
## Version History

### v2.0 (2024-01-15)
- Updated for Python 3.12
- Added new authentication methods
- Source: requests docs v2.31

### v1.0 (2023-06-01)
- Initial version
- Source: requests docs v2.28
```
