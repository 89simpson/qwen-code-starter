---
name: research
description: Technical research and investigation procedures
---

# Research Skill

## Purpose

Conduct thorough technical research to inform decisions, solve problems, and stay current with best practices.

## When to Use

- Evaluating new technologies or libraries
- Investigating bugs or issues
- Learning unfamiliar domains
- Comparing implementation approaches
- Before making architectural decisions

## Research Process

### 1. Define the Question

**Clear Research Goal:**
```
Bad: "Look into authentication"
Good: "Compare JWT vs session-based auth for our SPA"
```

**Scope Boundaries:**
- Time limit (e.g., 2 hours max)
- Specific aspects to investigate
- Decision criteria

### 2. Gather Information

**Primary Sources:**
- Official documentation
- API references
- RFCs and specifications
- Source code (for libraries)

**Secondary Sources:**
- Technical blogs
- Conference talks
- Community discussions
- Stack Overflow

**Evaluation Criteria:**
- Source credibility
- Publication date
- Community consensus
- Real-world usage

### 3. Analyze Options

**Comparison Framework:**
```markdown
| Criteria      | Option A | Option B | Option C |
|---------------|----------|----------|----------|
| Performance   | High     | Medium   | Low      |
| Complexity    | Medium   | Low      | High     |
| Community     | Large    | Small    | Medium   |
| Maintenance   | Active   | Active   | Limited  |
```

**Weighted Decision:**
1. List decision criteria
2. Assign weights (1-5)
3. Score each option
4. Calculate weighted scores

### 4. Validate Findings

**Proof of Concept:**
```bash
# Create minimal test
mkdir poc-auth-comparison
cd poc-auth-comparison

# Test each option
npm install jwt-library
# ... implement and test
```

**Check Real-World Usage:**
- GitHub stars and activity
- npm/PyPI download stats
- Production case studies
- Known issues/limitations

### 5. Document and Recommend

**Research Summary:**
```markdown
# Research: Authentication Options

## Question
Which authentication approach should we use for our SPA?

## Options Considered
1. JWT with refresh tokens
2. Session-based with Redis
3. OAuth2 with external provider

## Recommendation
JWT with refresh tokens

## Rationale
- Stateless scale better for our architecture
- Mobile-friendly
- Well-supported in our stack

## Trade-offs
- Token revocation more complex
- Larger payload size

## Implementation Notes
- Use httpOnly cookies for refresh tokens
- Set short expiry (15min) for access tokens
```

## Research Techniques

### Reading Documentation

**Effective Strategy:**
1. Start with "Getting Started"
2. Skim API reference for capabilities
3. Read guides for common patterns
4. Check FAQ for pitfalls

**Take Notes:**
```markdown
## Library: Express.js

### Key Concepts
- Middleware pattern
- Request/Response objects
- Router

### Common Patterns
```javascript
app.use(middleware);
app.get('/path', handler);
```

### Gotchas
- Error handling must be explicit
- Middleware order matters
```

### Code Investigation

**Read Source:**
```bash
# Clone repository
git clone https://github.com/library/repo

# Find relevant code
grep -r "function_name" src/

# Read implementation
cat src/module/file.py
```

**Understand Flow:**
1. Entry point
2. Key functions
3. Data flow
4. Edge cases handled

### Debugging Research

**Reproduce Issue:**
```bash
# Create minimal reproduction
git clone my-project
cd my-project

# Isolate the problem
# ... narrow down to specific code
```

**Gather Context:**
- Error messages (full stack trace)
- Environment details
- Steps to reproduce
- Expected vs actual behavior

**Search Effectively:**
```
Bad: "python error"
Good: "python sqlalchemy IntegrityError duplicate key"
Better: "site:github.com sqlalchemy IntegrityError duplicate key"
```

## Information Sources

### Official Documentation

| Type | Examples |
|------|----------|
| Language | docs.python.org, developer.mozilla.org |
| Framework | react.dev, django.readthedocs.io |
| Library | GitHub README, pkg.go.dev |
| API | Swagger/OpenAPI docs |

### Community Resources

| Resource | Best For |
|----------|----------|
| Stack Overflow | Specific errors, common issues |
| GitHub Issues | Bugs, feature requests |
| Reddit (r/programming) | Trends, discussions |
| Discord/Slack | Real-time help |
| Dev.to/Medium | Tutorials, experiences |

### Performance Data

| Source | What to Find |
|--------|--------------|
| Benchmarks | Raw performance |
| Profiling tools | Bottlenecks |
| Load testing | Scale characteristics |
| Real user monitoring | Production performance |

## Evaluation Framework

### Library Evaluation

```markdown
## Library: [Name]

### Basics
- Version: x.y.z
- License: MIT/Apache/etc.
- Size: X KB

### Community
- Stars: X
- Contributors: X
- Last commit: date
- Open issues: X

### Quality
- Test coverage: X%
- Documentation: Good/Fair/Poor
- Type hints: Yes/Partial/No

### Compatibility
- Python/Node versions: X+
- Dependencies: X direct, Y total
- Breaking changes: Known issues

### Verdict
Recommended / Use with caution / Avoid
```

### Technology Comparison

```markdown
## Comparison: X vs Y

### Criteria
1. Performance (weight: 3)
2. Ease of use (weight: 2)
3. Community support (weight: 2)
4. Maintenance (weight: 3)

### Scores

| Criteria | X | Y |
|----------|---|---|
| Performance | 4 | 3 |
| Ease of use | 3 | 5 |
| Community | 5 | 3 |
| Maintenance | 4 | 4 |

### Weighted Total
X: (4×3 + 3×2 + 5×2 + 4×3) = 40
Y: (3×3 + 5×2 + 3×2 + 4×3) = 37

### Recommendation
X is recommended due to better performance and community support.
```

## Time Management

### Time-Boxed Research

```
30 minutes: Initial exploration
1 hour: Deep dive into top options
30 minutes: POC for leading candidate
30 minutes: Documentation and recommendation
```

### Know When to Stop

**Good Stopping Points:**
- Clear winner emerges
- Time box expired
- Diminishing returns
- Have enough for decision

**Continue Research If:**
- Options too close to call
- Critical decision
- Significant investment
- High risk of being wrong

## Common Pitfalls

### Analysis Paralysis
- Too many options
- Endless research
- No decision made

**Solution:** Time-box, set decision criteria upfront

### Confirmation Bias
- Only looking for evidence supporting preference
- Ignoring contradictory data

**Solution:** Actively seek disconfirming evidence

### Shiny Object Syndrome
- Newest technology without justification
- Ignoring proven solutions

**Solution:** Evaluate against requirements, not hype

### Documentation Diving
- Reading everything cover to cover
- Not focusing on relevant parts

**Solution:** Search for specific information, skim rest

## Output Templates

### Research Brief

```markdown
# Research Brief: [Topic]

## Question
[What we're trying to answer]

## Context
[Why this matters, background]

## Constraints
[Time, budget, technical]

## Success Criteria
[What a good answer looks like]

## Deadline
[When needed by]
```

### Research Report

```markdown
# Research Report: [Topic]

## Executive Summary
[Key findings in 2-3 sentences]

## Background
[Context and motivation]

## Methodology
[How research was conducted]

## Findings
[Detailed results]

## Analysis
[Interpretation of findings]

## Recommendations
[What should be done]

## Appendix
[Supporting data, references]
```
