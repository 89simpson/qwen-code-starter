---
name: finish
description: Task completion checklist and delivery procedures
---

# Finish Skill

## Purpose

Ensure tasks are properly completed, tested, documented, and ready for integration or deployment.

## When to Use

- Completing a feature implementation
- Finishing a bug fix
- Wrapping up a refactoring task
- Before marking a task as done

## Completion Checklist

### Code Quality

- [ ] Code follows project style guidelines
- [ ] No linting errors or warnings
- [ ] No TODO comments left (or documented)
- [ ] No debug code (console.log, pdb, etc.)
- [ ] No commented-out code
- [ ] Proper error handling implemented
- [ ] Input validation in place

### Testing

- [ ] Unit tests written and passing
- [ ] Integration tests (if applicable)
- [ ] Edge cases covered
- [ ] Error scenarios tested
- [ ] Test coverage maintained or improved
- [ ] Tests are deterministic (no flakiness)

### Documentation

- [ ] Code comments for complex logic
- [ ] Function/class docstrings
- [ ] README updated (if user-facing change)
- [ ] API documentation updated
- [ ] Changelog entry added
- [ ] Migration guide (if breaking change)

### Security

- [ ] No secrets or credentials in code
- [ ] Input sanitization implemented
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] Authentication/authorization checks
- [ ] Sensitive data not logged

### Performance

- [ ] No obvious performance issues
- [ ] Database queries optimized
- [ ] N+1 queries avoided
- [ ] Caching considered where appropriate
- [ ] Large data handled efficiently

### Integration

- [ ] Compatible with existing code
- [ ] No breaking changes (or documented)
- [ ] Dependencies updated (if needed)
- [ ] Configuration documented
- [ ] Environment variables defined

## Delivery Steps

### 1. Final Code Review

Self-review checklist:
```
□ Would I approve this PR?
□ Is the code clear and maintainable?
□ Are there any edge cases missed?
□ Is error handling adequate?
```

### 2. Run Full Test Suite

```bash
# All tests
npm test
# or
pytest
# or
go test ./...

# With coverage
npm test -- --coverage
# or
pytest --cov
```

### 3. Build Verification

```bash
# Build the project
npm run build
# or
go build
# or
docker build .

# Verify no errors or warnings
```

### 4. Lint and Format

```bash
# Run linter
npm run lint
# or
flake8 .
# or
golangci-lint run

# Format code
npm run format
# or
black .
# or
gofmt -w .
```

### 5. Update Documentation

Files to check:
- README.md
- API documentation
- QWEN.md (if project changes)
- Changelog
- Any relevant wikis or docs

### 6. Prepare Commit/PR

Commit message:
```
type(scope): Clear description of change

Detailed explanation of what was done and why.
Include any relevant context or decisions.

Fixes #issue-number
```

PR Description:
```markdown
## Changes
- What was changed
- Why it was changed

## Testing
- How it was tested
- Test coverage

## Checklist
- [ ] Tests pass
- [ ] Linting passes
- [ ] Documentation updated
- [ ] Breaking changes documented
```

## Sign-Off Criteria

### Ready to Merge

All of the following must be true:
- ✅ All tests pass
- ✅ Code review completed
- ✅ Documentation updated
- ✅ No security issues
- ✅ Performance acceptable

### Ready to Deploy

Additionally:
- ✅ Deployed to staging
- ✅ Staging tests pass
- ✅ Rollback plan ready
- ✅ Monitoring configured

### Task Complete

Finally:
- ✅ Deployed to production (if applicable)
- ✅ Verified in production
- ✅ Stakeholders notified
- ✅ Task marked complete

## Communication

### Update Stakeholders

Template for completion notification:
```
✅ Task Complete: [Task Name]

Summary: [Brief description of what was done]

Changes:
- [Key change 1]
- [Key change 2]

Testing: [How it was tested]

Documentation: [Where to find docs]

Next Steps: [Any follow-up needed]
```

### Mark Task Complete

- Update project board (Jira, Linear, GitHub Projects)
- Close associated issues
- Update any tracking documents
- Notify relevant team members

## Post-Completion

### Monitor

After deployment:
- Watch error rates
- Check performance metrics
- Monitor user feedback
- Be available for questions

### Retrospective

For significant tasks:
- What went well?
- What could be improved?
- Lessons learned?
- Process improvements?

### Knowledge Sharing

- Update team documentation
- Share in team meeting (if significant)
- Add to onboarding docs
- Create runbook (if operational)

## Common Pitfalls

### Rushing to Finish

❌ Skipping tests to meet deadline
❌ Skipping documentation
❌ Not reviewing code properly

✅ Better to communicate delay than ship broken code

### Incomplete Testing

❌ Only testing happy path
❌ Not testing edge cases
❌ Skipping integration tests

✅ Test like a user (and attacker) would use it

### Poor Documentation

❌ "The code is self-documenting"
❌ Outdated README
❌ Missing API docs

✅ Future you will thank present you

## Templates

### Completion Report

```markdown
# Task Completion Report

## Task
[Task name and ID]

## Summary
[Brief overview of what was accomplished]

## Changes Made
- [Change 1]
- [Change 2]

## Testing
- [Test approach]
- [Coverage]

## Documentation
- [Updated docs]

## Known Limitations
- [Any remaining issues]

## Follow-up Items
- [Future improvements]
```
