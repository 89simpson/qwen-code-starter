---
name: commit-policy
description: Git commit conventions and best practices
---

# Commit Policy Rule

## Purpose

Establish consistent commit practices for clear history, easy debugging, and reliable rollbacks.

## Commit Message Format

### Structure

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Code style (formatting, semicolons) |
| `refactor` | Code refactoring (no behavior change) |
| `test` | Test additions or modifications |
| `chore` | Maintenance tasks, dependencies |
| `perf` | Performance improvements |
| `ci` | CI/CD configuration |
| `build` | Build system changes |
| `revert` | Reverting previous commits |

### Subject Line Rules

- Maximum 50 characters
- Start with capital letter
- No period at end
- Use imperative mood ("Add" not "Added")

**Examples:**
```
feat(auth): Add JWT token refresh endpoint
fix(api): Handle null user in profile endpoint
docs(readme): Update installation instructions
```

### Body (Optional)

- Wrap at 72 characters
- Explain WHAT and WHY, not HOW
- Reference issues and PRs

### Footer (Optional)

- Breaking changes: `BREAKING CHANGE: <description>`
- Issue references: `Fixes #123`, `Closes #456`
- Co-authors: `Co-authored-by: Name <email>`

## Commit Examples

### Good Commits

```
feat(search): Add full-text search for articles

Implemented Elasticsearch integration for article search.
Uses standard analyzers for English text.

Fixes #234
```

```
fix(payment): Validate card expiry before processing

Prevents invalid cards from reaching payment processor.
Added validation for past dates and invalid months.

BREAKING CHANGE: Card validation now rejects past expiry dates
```

```
refactor(users): Extract email validation to utility

Moves email validation logic to shared utils module.
No behavior change, improves code reusability.
```

### Bad Commits

```
fix stuff
```

```
Updated code
```

```
WIP
```

```
asdfasdf
```

## Commit Size

### Ideal Commit

- Single logical change
- 50-200 lines changed
- Clear, testable unit
- Can be reverted independently

### Too Large

- Multiple unrelated changes
- >500 lines changed
- Hard to review
- Risky to revert

### Split Large Changes

```
# Bad: One giant commit
- Add user model
- Add authentication
- Add password reset
- Add user settings

# Good: Separate commits
feat(users): Add user model
feat(auth): Add JWT authentication
feat(auth): Add password reset flow
feat(users): Add user settings endpoint
```

## Before Committing

### Checklist

- [ ] Code compiles/builds
- [ ] Tests pass
- [ ] Linting passes
- [ ] No debug code left
- [ ] No sensitive data
- [ ] Commit message follows format

### Commands

```bash
# Check status
git status

# Review changes
git diff

# Run tests
npm test  # or pytest, go test, etc.

# Run linter
npm run lint

# Stage changes
git add <files>

# Commit
git commit -m "type(scope): description"
```

## Branch Naming

### Format

```
<type>/<description>
```

### Examples

```
feat/user-authentication
fix/payment-validation
docs/api-documentation
refactor/database-layer
```

### Avoid

```
patch-1
test
my-branch
fix-stuff
```

## Commit Workflow

### Small Changes

```bash
git add <files>
git commit -m "fix(api): Handle edge case in user lookup"
git push
```

### Larger Changes

```bash
# Create feature branch
git checkout -b feat/new-feature

# Work in logical commits
git add src/auth/login.py
git commit -m "feat(auth): Add login endpoint"

git add src/auth/logout.py
git commit -m "feat(auth): Add logout endpoint"

# Push and create PR
git push -u origin feat/new-feature
```

### Squash Before Merge

For WIP commits, squash before merging:
```bash
# Interactive rebase
git rebase -i HEAD~3

# Then squash appropriate commits
```

## Handling Mistakes

### Amend Last Commit

```bash
# Fix commit message
git commit --amend -m "feat(auth): Add login endpoint"

# Add forgotten file
git add forgotten_file.py
git commit --amend --no-edit
```

### Revert Commit

```bash
# Revert specific commit
git revert <commit-hash>
git commit -m "revert: Undo problematic change"
```

### Fix Wrong Branch

```bash
# Committed to wrong branch
git checkout correct-branch
git cherry-pick <commit-hash>
git checkout wrong-branch
git reset --hard HEAD~1
```

## Pre-commit Hooks

### Recommended Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Run linter
npm run lint
if [ $? -ne 0 ]; then
    echo "Linting failed"
    exit 1
fi

# Run tests
npm test
if [ $? -ne 0 ]; then
    echo "Tests failed"
    exit 1
fi

# Check for secrets
if grep -r "password\|secret\|api_key" --include="*.py" --include="*.js" .; then
    echo "Potential secrets found"
    exit 1
fi
```

## History Maintenance

### Before Pushing

- Rebase to clean up history
- Squash WIP commits
- Ensure all commits build

### After Pushing

- Don't rewrite public history
- Use revert, not reset
- Coordinate with team
