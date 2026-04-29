---
name: housekeeping
description: Code cleanup and maintenance procedures
---

# Housekeeping Skill

## Purpose

Maintain code quality through regular cleanup, refactoring, and technical debt management.

## When to Use

- After completing features
- During dedicated maintenance sprints
- When encountering code smells
- Before major releases
- As part of regular development workflow

## Code Cleanup Tasks

### Remove Dead Code

**Identify:**
```bash
# Unused imports (Python)
flake8 --select=F401 .

# Unused variables (JavaScript)
eslint --rule 'no-unused-vars: error'

# Dead code detection
vulture .  # Python
ts-prune     # TypeScript
```

**Remove:**
- Unused imports
- Unused variables
- Unreachable code
- Commented-out code
- Unused functions/classes

### Fix Code Style

**Automated:**
```bash
# Python
black .
isort .
flake8 .

# JavaScript/TypeScript
prettier --write .
eslint --fix .

# Go
gofmt -w .
goimports -w .
```

**Manual Review:**
- Inconsistent naming
- Inconsistent formatting
- Line length violations
- Missing docstrings

### Update Dependencies

**Check for Updates:**
```bash
# Python
pip list --outdated
pipreqs . --force

# Node.js
npm outdated
npx npm-check-updates

# Go
go list -u -m all
```

**Update Safely:**
1. Update one dependency at a time
2. Run tests after each update
3. Check for breaking changes
4. Update lock files
5. Commit with clear message

### Fix Security Vulnerabilities

**Scan:**
```bash
# Python
safety check
bandit -r src/

# Node.js
npm audit
npx audit-ci

# General
snyk test
```

**Fix:**
- Update vulnerable packages
- Replace deprecated libraries
- Fix identified vulnerabilities
- Document exceptions if needed

## Refactoring

### Common Refactoring Patterns

**Extract Method:**
```python
# Before
def process_order(order):
    # Calculate subtotal
    subtotal = sum(item.price * item.qty for item in order.items)
    # Calculate tax
    tax = subtotal * 0.1
    # Calculate total
    total = subtotal + tax
    return total

# After
def process_order(order):
    subtotal = calculate_subtotal(order.items)
    tax = calculate_tax(subtotal)
    return subtotal + tax
```

**Rename for Clarity:**
```python
# Before
def calc(d, r):
    return d * r

# After
def calculate_total_price(quantity, unit_price):
    return quantity * unit_price
```

**Reduce Nesting:**
```python
# Before
def process(user):
    if user:
        if user.active:
            if user.has_permission:
                return do_something()
    return None

# After
def process(user):
    if not user:
        return None
    if not user.active:
        return None
    if not user.has_permission:
        return None
    return do_something()
```

### Technical Debt Tracking

**Add TODO Comments:**
```python
# TODO: Refactor this function - too complex
# FIXME: This causes issues with large datasets
# HACK: Temporary workaround for API bug
# XXX: Security concern - needs review
```

**Track in Issue Tracker:**
```markdown
## Technical Debt

### High Priority
- [ ] Fix N+1 query in user list
- [ ] Add rate limiting to API

### Medium Priority  
- [ ] Refactor auth module
- [ ] Improve error messages

### Low Priority
- [ ] Update deprecated dependencies
- [ ] Add more unit tests
```

## Documentation Cleanup

### Update Comments

**Remove:**
- Obvious comments (`# increment i by 1`)
- Outdated comments
- TODO items that are done

**Add:**
- Why, not what (for complex logic)
- Assumptions and constraints
- References to documentation

### Update README

Check and update:
- Installation instructions
- Usage examples
- API documentation
- Contributing guidelines
- Badge status

### Update QWEN.md

Review and update:
- Tech stack changes
- New development practices
- Updated constraints
- New quality standards

## File Organization

### Clean Directories

**Remove:**
- Empty directories
- Temporary files
- Build artifacts
- Old backups

**Organize:**
- Group related files
- Follow naming conventions
- Maintain consistent structure

### Update .gitignore

```bash
# Check for ignored files that are tracked
git ls-files -i --exclude-standard

# Add common patterns
echo "*.pyc" >> .gitignore
echo "__pycache__/" >> .gitignore
echo ".env" >> .gitignore
```

## Automated Maintenance

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
  
  - repo: https://github.com/psf/black
    rev: 23.0.0
    hooks:
      - id: black
  
  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
```

### CI/CD Checks

```yaml
# GitHub Actions
name: Code Quality

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run linters
        run: |
          black --check .
          flake8 .
          isort --check-only .
  
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run security scan
        run: |
          pip install safety bandit
          safety check
          bandit -r src/
```

## Housekeeping Checklist

### Daily
- [ ] Format code before committing
- [ ] Remove debug statements
- [ ] Update comments if needed

### Weekly
- [ ] Run full linting
- [ ] Check for dependency updates
- [ ] Review TODO comments

### Monthly
- [ ] Security scan
- [ ] Dependency audit
- [ ] Documentation review
- [ ] Technical debt review

### Quarterly
- [ ] Major refactoring
- [ ] Architecture review
- [ ] Process improvements
- [ ] Tool updates

## Metrics to Track

### Code Quality
- Linting violations
- Test coverage
- Code duplication
- Cyclomatic complexity

### Dependencies
- Outdated packages
- Security vulnerabilities
- Unused dependencies

### Documentation
- Docstring coverage
- README freshness
- API documentation accuracy
