---
name: logging
description: Logging standards and best practices
---

# Logging Rule

## Purpose

Establish consistent logging practices for debugging, monitoring, and auditing across the application.

## Log Levels

### DEBUG
**Purpose:** Detailed diagnostic information for development

**When to use:**
- Function entry/exit with parameters
- Variable values during complex operations
- Detailed flow tracing

**Example:**
```python
logger.debug(f"Processing user {user_id} with options {options}")
```

**Note:** Never log sensitive data at DEBUG level

### INFO
**Purpose:** Normal operational messages

**When to use:**
- Application startup/shutdown
- Successful operations
- State changes
- User actions (non-security)

**Example:**
```python
logger.info(f"User {user_id} logged in successfully")
logger.info("Database migration completed")
```

### WARN
**Purpose:** Unexpected but handled situations

**When to use:**
- Deprecated API usage
- Recoverable errors
- Performance concerns
- Unusual but valid conditions

**Example:**
```python
logger.warn(f"API response took {duration}s (threshold: 1s)")
logger.warn("Falling back to cache, database unavailable")
```

### ERROR
**Purpose:** Errors that prevent operation completion

**When to use:**
- Unhandled exceptions
- Failed external calls
- Data integrity issues
- Configuration problems

**Example:**
```python
logger.error(f"Failed to process payment: {error}", exc_info=True)
```

### CRITICAL / FATAL
**Purpose:** System-wide failures requiring immediate attention

**When to use:**
- Application crash
- Data corruption
- Security breaches
- Complete service outage

**Example:**
```python
logger.critical("Database connection pool exhausted", exc_info=True)
```

## Log Content

### Include

- Timestamp (automatic via logger)
- Log level
- Component/module name
- Correlation ID for request tracing
- Relevant context (user IDs, resource IDs)
- Error details and stack traces

### Exclude

- Passwords and secrets
- Full credit card numbers (log last 4 only)
- Personal identifiable information (PII)
- Internal IP addresses and URLs
- Stack traces for expected errors

## Structured Logging

### Use JSON Format

```python
# Good: Structured logging
logger.info("payment_processed", extra={
    "user_id": user_id,
    "amount": amount,
    "currency": currency,
    "transaction_id": txn_id
})

# Output:
# {"level": "INFO", "message": "payment_processed", 
#  "user_id": 123, "amount": 99.99, "currency": "USD"}
```

### Consistent Field Names

| Field | Description | Example |
|-------|-------------|---------|
| `user_id` | User identifier | `12345` |
| `request_id` | Request correlation ID | `req-abc123` |
| `duration_ms` | Operation duration | `145` |
| `error_code` | Error identifier | `PAYMENT_FAILED` |
| `resource` | Affected resource | `users/123` |

## Request Tracing

### Correlation IDs

Generate and propagate request IDs:
```python
# Generate at request entry
request_id = generate_uuid()
logger.bind(request_id=request_id)

# All subsequent logs include request_id
logger.info("Processing request")  # Includes request_id
```

### Distributed Tracing

For microservices:
```python
# Propagate trace context
headers = {
    "X-Request-ID": request_id,
    "X-Trace-ID": trace_id,
    "X-Span-ID": span_id
}
```

## Performance Logging

### Log Slow Operations

```python
import time

start = time.time()
result = expensive_operation()
duration = time.time() - start

if duration > SLOW_THRESHOLD:
    logger.warn(f"Slow operation: {duration:.2f}s")
```

### Log Resource Usage

```python
logger.debug(f"Memory usage: {get_memory_usage()}MB")
logger.debug(f"Active connections: {pool.size()}")
```

## Error Logging

### Include Context

```python
try:
    process_payment(user_id, amount)
except PaymentError as e:
    logger.error(
        f"Payment failed for user {user_id}",
        extra={
            "user_id": user_id,
            "amount": amount,
            "error_code": e.code
        },
        exc_info=True
    )
```

### Don't Log

```python
# Bad: No context
logger.error("Payment failed")

# Bad: Sensitive data
logger.error(f"Payment failed with card {card_number}")

# Bad: Swallowing error
try:
    risky_operation()
except Exception:
    pass  # Silent failure
```

## Log Configuration

### Development

```python
LOG_LEVEL = 'DEBUG'
LOG_FORMAT = 'console'  # Human-readable
LOG_OUTPUT = 'stdout'
```

### Production

```python
LOG_LEVEL = 'INFO'
LOG_FORMAT = 'json'  # Machine-parseable
LOG_OUTPUT = 'stdout'  # Let container handle
```

### Testing

```python
LOG_LEVEL = 'WARNING'  # Reduce noise
LOG_OUTPUT = 'null'  # Or capture for assertions
```

## Log Rotation

### Configure Rotation

```python
from logging.handlers import RotatingFileHandler

handler = RotatingFileHandler(
    'app.log',
    maxBytes=10*1024*1024,  # 10MB
    backupCount=5
)
```

### Retention Policy

- DEBUG logs: 1 day
- INFO logs: 7 days
- WARN+ logs: 30 days
- Audit logs: As required by compliance

## Monitoring Integration

### Alert on Patterns

- Error rate spikes
- Specific error codes
- Missing expected logs
- Log volume anomalies

### Log Aggregation

Send logs to central system:
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Splunk
- CloudWatch Logs
- Datadog Logs

## Testing Logs

### Assert Log Output

```python
import logging
from io import StringIO

def test_logs_error_on_failure():
    log_output = StringIO()
    handler = logging.StreamHandler(log_output)
    logger.addHandler(handler)
    
    process_invalid_input()
    
    assert "Invalid input" in log_output.getvalue()
    assert handler.level == logging.ERROR
```
