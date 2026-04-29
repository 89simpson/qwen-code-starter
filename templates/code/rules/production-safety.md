---
name: production-safety
description: Safeguards for production code and data
---

# Production Safety Rule

## Purpose

Protect production systems, data, and users by implementing strict safeguards around production code and operations.

## Core Principles

### 1. Never Break Production

- No untested changes to production
- No direct production database modifications
- No ad-hoc production debugging that modifies state

### 2. Defense in Depth

- Multiple layers of protection
- Fail safely (fail closed, not open)
- Graceful degradation over crashes

### 3. Audit Trail

- Log all production changes
- Track who changed what and when
- Maintain rollback capability

## Production Code Guidelines

### Before Deploying to Production

Checklist:
- [ ] Tests pass locally
- [ ] Tests pass in CI
- [ ] Code review completed
- [ ] Rollback plan in place
- [ ] Monitoring/alerts configured
- [ ] Documentation updated

### Code Changes

**Safe:**
- Bug fixes with tests
- Backward-compatible additions
- Performance optimizations (with benchmarks)

**Requires Extra Review:**
- Schema changes
- API contract changes
- Authentication/authorization changes
- Payment or financial logic

**Never Without Explicit Approval:**
- Data migrations
- Breaking changes
- Security-sensitive modifications

## Database Safety

### Read Operations
- Generally safe with proper indexing
- Avoid SELECT * in production code
- Use pagination for large result sets

### Write Operations
- Always use transactions for multi-step operations
- Implement idempotency where possible
- Add audit logging for sensitive changes

### Schema Changes
- Write migration scripts (never manual)
- Test migrations on staging first
- Ensure backward compatibility during rollout
- Have rollback migrations ready

```sql
-- Good: Migration script
-- Bad: Manual ALTER TABLE in production
```

## Secret Management

### Never Commit
- API keys
- Database passwords
- Private keys
- OAuth credentials
- Internal URLs with auth

### Use Environment Variables
```bash
# .env (not committed)
DATABASE_URL=postgresql://...
API_KEY=sk-...

# Code
db_url = os.environ.get('DATABASE_URL')
```

### Rotation
- Rotate secrets on schedule
- Immediately if potentially compromised
- Update all environments together

## Error Handling

### Production Errors

**Do:**
- Log with appropriate detail
- Return user-friendly messages
- Alert on critical errors
- Include correlation IDs

**Don't:**
- Expose stack traces to users
- Log sensitive data
- Swallow errors silently
- Crash on expected errors

### Error Categories

| Category | Log Level | Alert | User Message |
|----------|-----------|-------|--------------|
| Bug/Crash | ERROR | Yes | "Something went wrong" |
| Expected | INFO | No | (silent) |
| Security | ERROR | Yes | "Unauthorized" |
| Validation | WARN | No | "Invalid input" |

## Rollback Procedures

### Before Any Change

1. Document rollback steps
2. Verify rollback works in staging
3. Ensure rollback doesn't lose data
4. Set rollback trigger conditions

### Rollback Triggers

- Error rate spikes
- Performance degradation
- Failed health checks
- User-reported issues

## Monitoring Requirements

### Essential Metrics
- Error rates
- Response latency (p50, p95, p99)
- Request volume
- Resource utilization

### Alert Thresholds
- Error rate > 1%
- p99 latency > 1s
- CPU/Memory > 80%
- Failed health checks

## Incident Response

### When Things Go Wrong

1. **Acknowledge** - Confirm the issue
2. **Assess** - Understand impact
3. **Act** - Mitigate or rollback
4. **Analyze** - Post-mortem later

### During Incidents

- Focus on restoration, not root cause
- Communicate status clearly
- Document actions taken
- Preserve evidence for analysis

## Testing Production Safeguards

### Regular Drills
- Test rollback procedures
- Verify monitoring alerts
- Practice incident response
- Review access controls

### Chaos Engineering
- Test failure scenarios
- Verify graceful degradation
- Confirm alerting works
- Validate backups
