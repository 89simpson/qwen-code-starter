---
name: project-name
type: code
framework-version: 1.0.0
template-version: 1.0.0
last-updated: 2026-04-29
---

# Project Passport

## Project Overview

**Name:** [Project Name]

**Type:** Code Project

**Description:** [Brief description of the project]

**Repository:** [Repository URL]

## Goals

<!-- Define the primary goals of this project. This helps Qwen Code understand priorities. -->

1. [Primary goal]
2. [Secondary goal]
3. [Tertiary goal]

## Tech Stack

<!-- List the main technologies used in this project -->

### Languages
- [e.g., Python 3.11+]
- [e.g., TypeScript 5.x]

### Frameworks
- [e.g., FastAPI]
- [e.g., React 18]

### Databases
- [e.g., PostgreSQL 15]
- [e.g., Redis 7]

### Infrastructure
- [e.g., Docker]
- [e.g., AWS]

## Architecture

<!-- Brief overview of the project architecture -->

```
[Architecture diagram or description]
```

## Development Practices

### Code Style
- Follow existing code conventions
- Use meaningful variable and function names
- Keep functions small and focused (single responsibility)
- Write self-documenting code with comments only when necessary

### Project Structure
- Respect the existing directory structure
- Place new files in appropriate directories
- Follow naming conventions (snake_case for Python, camelCase for JavaScript)

### Dependencies
- Check for existing solutions before adding new dependencies
- Pin dependency versions in lock files
- Document new dependencies in README

## Project Constraints

### File Access
- Do not modify files in `.qwen/` unless explicitly asked
- Respect `.qwenignore` patterns
- Do not commit sensitive files (`.env`, keys, credentials)

### Scope Boundaries
- Stay within the scope of the current task
- Ask before making breaking changes
- Preserve backward compatibility when possible

### Performance
- Consider performance implications of new code
- Avoid unnecessary database queries
- Cache expensive operations when appropriate

## Quality Standards

### Code Review Checklist
- [ ] Code follows project style guidelines
- [ ] Tests are included for new functionality
- [ ] No sensitive data is exposed
- [ ] Error handling is appropriate
- [ ] Logging is adequate for debugging

### Documentation
- Update README for significant changes
- Document public APIs
- Add inline comments for complex logic

## Testing Requirements

### Test Coverage
- Write tests for new functionality
- Maintain or improve overall coverage
- Include unit tests, integration tests as appropriate

### Test Execution
```bash
# Run all tests
[command to run tests]

# Run specific test file
[command to run specific test]
```

### Test Standards
- Tests should be independent and idempotent
- Use descriptive test names
- Mock external dependencies appropriately

## Security Guidelines

### Secrets Management
- Never commit secrets or credentials
- Use environment variables for configuration
- Rotate secrets regularly

### Input Validation
- Validate all user inputs
- Sanitize data before database queries
- Use parameterized queries to prevent injection

### Authentication & Authorization
- Implement proper authentication flows
- Check authorization before sensitive operations
- Use established libraries for crypto operations

## Performance Requirements

### Response Times
- API endpoints: < 200ms (p95)
- Database queries: < 100ms (p95)
- Page loads: < 2s

### Scaling
- Design for horizontal scaling where applicable
- Use connection pooling for databases
- Implement caching for frequently accessed data

## Documentation Standards

### Code Documentation
- Docstrings for public functions and classes
- README for module-level documentation
- Inline comments for complex algorithms

### API Documentation
- OpenAPI/Swagger for REST APIs
- Include request/response examples
- Document error codes and messages

## Deployment Procedures

### Pre-deployment Checklist
- [ ] All tests pass
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Environment variables configured
- [ ] Database migrations prepared

### Deployment Steps
```bash
# 1. Build
[build command]

# 2. Migrate
[migration command]

# 3. Deploy
[deploy command]

# 4. Verify
[verification command]
```

## Monitoring Requirements

### Logging
- Log at appropriate levels (DEBUG, INFO, WARN, ERROR)
- Include correlation IDs for request tracing
- Never log sensitive data

### Metrics
- Track request latency
- Monitor error rates
- Alert on anomalies

### Health Checks
- Implement health check endpoints
- Include dependency status
- Return appropriate HTTP status codes

---

*This QWEN.md is managed by Qwen Code Starter v1.0.0*
*For updates, run: init-project.sh*
