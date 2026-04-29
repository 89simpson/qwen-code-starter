---
name: testing
description: Test execution and quality assurance procedures
---

# Testing Skill

## Purpose

Execute comprehensive testing to ensure code quality, reliability, and correctness before deployment.

## When to Use

- After implementing new features
- Before merging pull requests
- When fixing bugs
- During code reviews
- Before deployments

## Test Types

### Unit Tests

**Purpose:** Test individual functions/components in isolation

**Characteristics:**
- Fast execution
- No external dependencies
- Mock external services
- High coverage target (80%+)

**Example:**
```python
def test_calculate_total():
    items = [Item(10), Item(20)]
    assert calculate_total(items) == 30
```

### Integration Tests

**Purpose:** Test component interactions

**Characteristics:**
- Test boundaries between components
- May use test database
- Slower than unit tests
- Focus on critical paths

**Example:**
```python
def test_user_registration_flow():
    response = client.post('/register', json={
        'email': 'test@example.com',
        'password': 'secure123'
    })
    assert response.status_code == 201
    assert User.exists(email='test@example.com')
```

### End-to-End (E2E) Tests

**Purpose:** Test complete user workflows

**Characteristics:**
- Full system testing
- Slowest execution
- Test critical user journeys
- Often automated with Selenium/Playwright

**Example:**
```python
def test_checkout_flow():
    login('user@example.com', 'password')
    add_to_cart('product-123')
    proceed_to_checkout()
    enter_payment_info()
    assert order_confirmed()
```

### Performance Tests

**Purpose:** Verify performance requirements

**Characteristics:**
- Load testing
- Stress testing
- Latency measurement
- Resource utilization

**Example:**
```bash
# Using k6
k6 run --vus 100 --duration 30s load-test.js
```

## Test Execution

### Run All Tests

```bash
# Python (pytest)
pytest

# With coverage
pytest --cov=src --cov-report=html

# Node.js (Jest)
npm test

# With coverage
npm test -- --coverage

# Go
go test ./...

# With coverage
go test -cover ./...
```

### Run Specific Tests

```bash
# By file
pytest tests/test_user.py

# By test name
pytest -k test_login

# By directory
pytest tests/unit/

# Node.js specific
npm test -- test-file.test.js

# Go specific
go test ./pkg/auth/...
```

### Run Tests in Watch Mode

```bash
# pytest watch
pytest-watch

# Jest watch
npm test -- --watch

# Go test with rerun
gotestsum --watch
```

## Test Organization

### Directory Structure

```
tests/
├── unit/           # Unit tests
│   ├── test_auth.py
│   └── test_utils.py
├── integration/    # Integration tests
│   ├── test_api.py
│   └── test_db.py
├── e2e/           # End-to-end tests
│   └── test_checkout.py
├── fixtures/      # Test data
│   └── sample_data.json
└── conftest.py    # Shared fixtures
```

### Naming Conventions

```
test_<function>.py          # Test files
test_<function_name>()      # Test functions
test_<class>_<method>()     # Class method tests
```

### Test Categories

```python
import pytest

@pytest.mark.unit
def test_something():
    pass

@pytest.mark.integration
@pytest.mark.slow
def test_slow_operation():
    pass

@pytest.mark.e2e
def test_full_workflow():
    pass
```

## Mocking and Fixtures

### Mocking External Services

```python
from unittest.mock import patch, MagicMock

@patch('requests.get')
def test_api_call(mock_get):
    mock_get.return_value.status_code = 200
    mock_get.return_value.json.return_value = {'data': 'test'}
    
    result = fetch_data()
    assert result == 'test'
```

### Database Fixtures

```python
@pytest.fixture
def test_db():
    db = create_test_database()
    yield db
    drop_test_database(db)

@pytest.fixture
def sample_user(test_db):
    return User.create(
        email='test@example.com',
        password='hashed_password'
    )
```

### Time Fixtures

```python
from freezegun import freeze_time

@freeze_time('2024-01-01 12:00:00')
def test_time_dependent_logic():
    assert get_current_hour() == 12
```

## Test Quality

### Good Test Characteristics

**FIRST Principles:**
- **F**ast: Tests should run quickly
- **I**solated: No dependencies between tests
- **R**epeatable: Same result every time
- **S**elf-validating: Clear pass/fail
- **T**imely: Written before/during development

### Test Coverage

```bash
# Check coverage
pytest --cov=src --cov-report=term-missing

# Fail below threshold
pytest --cov=src --cov-fail-under=80

# HTML report
pytest --cov=src --cov-report=html
open htmlcov/index.html
```

### Coverage Targets

| Test Type | Target Coverage |
|-----------|----------------|
| Unit | 80%+ |
| Integration | Critical paths |
| E2E | Key workflows |

## Continuous Integration

### CI Test Configuration

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: pip install -r requirements.txt
      
      - name: Run tests
        run: pytest --cov=src
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## Debugging Failed Tests

### Get More Information

```bash
# Verbose output
pytest -v

# Show local variables on failure
pytest -l

# Print output
pytest -s

# Stop on first failure
pytest -x

# Run last failed tests
pytest --lf
```

### Debug Interactive

```python
def test_debug():
    import pdb; pdb.set_trace()  # Breakpoint
    result = calculate_something()
    assert result == expected
```

## Common Issues

### Flaky Tests

**Causes:**
- Timing dependencies
- Shared state
- External service dependencies
- Random data

**Fixes:**
```python
# Use explicit waits, not sleep
from selenium.webdriver.support.ui import WebDriverWait

# Isolate test data
@pytest.fixture
def isolated_data():
    data = create_test_data()
    yield data
    cleanup_test_data(data)

# Mock external services
@patch('external_api.call')
```

### Slow Tests

**Optimization:**
```bash
# Identify slow tests
pytest --durations=10

# Parallel execution
pytest -n auto  # pytest-xdist

# Skip in CI if not needed
@pytest.mark.skipif(os.getenv('CI'), reason="Slow test")
```

### Test Data Management

**Best Practices:**
- Use factories, not fixtures for complex data
- Keep test data minimal
- Clean up after tests
- Use transactions for database tests

## Test Documentation

### Document Test Purpose

```python
def test_user_cannot_access_another_users_data():
    """
    Security test: Verify users can only access their own data.
    
    Regression test for issue #123 where user ID was not validated.
    """
```

### Document Test Data

```python
# Valid test card numbers (Stripe test data)
VALID_CARD = '4242424242424242'
EXPIRED_CARD = '4000000000000002'
DECLINED_CARD = '4000000000000002'
```
