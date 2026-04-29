---
name: local-first
description: Local development first, cloud second
---

# Local-First Rule

## Purpose

Prioritize local development workflows for faster iteration, better debugging, and reduced dependency on remote services.

## Core Philosophy

### Develop Locally, Deploy Remotely

- Run everything locally when possible
- Use cloud services only when necessary
- Mirror production locally for testing

### Benefits

- Faster feedback loops
- Works offline
- No cloud costs during development
- Better debugging experience
- More control over environment

## Local Development Setup

### Required Tools

Install and configure locally:
- Language runtime (Python, Node.js, etc.)
- Database (PostgreSQL, MySQL, etc.)
- Cache (Redis, Memcached)
- Message queue (RabbitMQ, Kafka) - if used

### Containerization

Use Docker for consistency:
```bash
# docker-compose.yml for local services
version: '3'
services:
  db:
    image: postgres:15
    ports:
      - "5432:5432"
  redis:
    image: redis:7
    ports:
      - "6379:6379"
```

### Environment Configuration

```bash
# .env.local (development)
DATABASE_URL=postgresql://localhost:5432/myapp_dev
REDIS_URL=redis://localhost:6379
DEBUG=true
```

## Local Services

### Database

**Preferred:** Run locally
```bash
# PostgreSQL
brew install postgresql
pg_ctl -D /usr/local/var/postgres start

# Or with Docker
docker run -d -p 5432:5432 postgres:15
```

**When to Use Cloud DB:**
- Database is too large for local
- Need specific managed features
- Team sharing a dev database

### Cache (Redis)

**Preferred:** Run locally
```bash
# Native
brew install redis
redis-server

# Docker
docker run -d -p 6379:6379 redis:7
```

### Message Queues

**Preferred:** Run locally for development
```bash
# RabbitMQ
docker run -d -p 5672:5672 rabbitmq:3

# Kafka (use lightweight alternative for dev)
docker run -d redpandadata/redpanda
```

## External Services

### Mocking Strategy

For external services, prefer mocks:

```python
# Good: Mock external API
@pytest.fixture
def mock_stripe():
    with patch('stripe.Charge.create') as mock:
        mock.return_value = {'id': 'ch_test'}
        yield mock

# Bad: Hit real API in tests
```

### When to Use Real Services

- Testing actual integration
- Verifying API compatibility
- Performance testing
- Before production deployment

### Local Alternatives

| Service | Local Alternative |
|---------|------------------|
| AWS S3 | MinIO, LocalStack |
| AWS SQS | LocalStack, moto |
| SendGrid | Mailhog, Mailpit |
| Stripe | Stripe CLI, test mode |
| Firebase | Firebase Emulator |

## Testing Locally

### Run All Tests Locally

```bash
# Full test suite
pytest                      # Python
npm test                    # Node.js
go test ./...              # Go
```

### Test Database

Use isolated test database:
```bash
# Create test DB
createdb myapp_test

# Run tests (auto rollback)
pytest --db=myapp_test
```

### Integration Tests

Run against local services:
```bash
# Start services
docker-compose up -d

# Run integration tests
pytest tests/integration/

# Stop services
docker-compose down
```

## Debugging Locally

### Use Local Debuggers

```bash
# Python
python -m pdb script.py

# Node.js
node --inspect script.js

# Go
dlv debug ./cmd/app
```

### Logging

Configure verbose logging locally:
```python
# settings.local.py
LOG_LEVEL = 'DEBUG'
LOG_FORMAT = 'detailed'
```

### Profiling

Profile locally before optimizing:
```bash
# Python
python -m cProfile script.py

# Node.js
node --prof script.js
```

## CI/CD Alignment

### Mirror CI Locally

```bash
# Run same commands as CI
./scripts/lint.sh
./scripts/test.sh
./scripts/build.sh
```

### Pre-commit Hooks

Catch issues before pushing:
```bash
# .git/hooks/pre-commit
#!/bin/bash
npm run lint
npm test
```

## Documentation

### Local Setup Guide

Document how to run locally:
```markdown
## Local Development

1. Install dependencies: `npm install`
2. Start services: `docker-compose up -d`
3. Run app: `npm run dev`
4. Open: http://localhost:3000
```

### Troubleshooting

Common local issues:
- Port conflicts
- Missing dependencies
- Database connection issues
- Permission problems
