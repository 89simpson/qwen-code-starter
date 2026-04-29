---
name: db-migrate
description: Database migration procedures and best practices
---

# DB Migrate Skill

## Purpose

Manage database schema changes safely through versioned migrations that can be applied and rolled back.

## When to Use

- Adding new tables or columns
- Modifying existing schema
- Data migrations
- Index creation/removal
- Constraint changes

## Migration Principles

### Key Rules

1. **Migrations are immutable** - Never edit applied migrations
2. **Migrations are forward-only** - Use separate rollback scripts
3. **Test on staging first** - Never run untested migrations in production
4. **Backwards compatible** - Support old and new code during rollout
5. **Idempotent when possible** - Safe to run multiple times

### Migration Types

| Type | Description | Risk Level |
|------|-------------|------------|
| Add column | Non-null with default | Low |
| Add table | New table creation | Low |
| Add index | Performance improvement | Low |
| Remove column | Data loss possible | Medium |
| Modify column | Type/constraint change | High |
| Data migration | Transform existing data | High |

## Creating Migrations

### Naming Convention

```
<timestamp>_<description>.sql
<version>_<description>.sql
```

**Examples:**
```
20240115_120000_add_users_email_index.sql
001_create_users_table.sql
002_add_password_hash_column.sql
```

### Migration Template

```sql
-- Migration: <description>
-- Created: <date>
-- Author: <author>
-- Rollback: <rollback description>

-- UP migration
BEGIN;

-- Your changes here
ALTER TABLE users ADD COLUMN email VARCHAR(255);
CREATE INDEX idx_users_email ON users(email);

COMMIT;

-- DOWN migration (separate file or section)
-- ALTER TABLE users DROP COLUMN email;
-- DROP INDEX idx_users_email;
```

## Migration Tools

### SQLAlchemy Alembic (Python)

```bash
# Initialize
alembic init alembic

# Create migration
alembic revision -m "add_email_column"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

**Migration file:**
```python
"""add_email_column

Revision ID: abc123
Revises: def456
Create Date: 2024-01-15 12:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

revision = 'abc123'
down_revision = 'def456'

def upgrade():
    op.add_column('users', sa.Column('email', sa.String(255)))
    op.create_index('idx_users_email', 'users', ['email'])

def downgrade():
    op.drop_index('idx_users_email', 'users')
    op.drop_column('users', 'email')
```

### Django Migrations

```bash
# Create migration
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Rollback
python manage.py migrate app_name 0001
```

### Node.js (Knex)

```bash
# Create migration
knex migrate:make add_email_column

# Run migrations
knex migrate:latest

# Rollback
knex migrate:rollback
```

**Migration file:**
```javascript
exports.up = function(knex) {
  return knex.schema.table('users', function(table) {
    table.string('email');
    table.index('email');
  });
};

exports.down = function(knex) {
  return knex.schema.table('users', function(table) {
    table.dropIndex(['email']);
    table.dropColumn('email');
  });
};
```

### Go (golang-migrate)

```bash
# Create migration
migrate create -ext sql -dir migrations -seq add_email_column

# Apply migrations
migrate -path migrations -database "postgres://..." up

# Rollback
migrate -path migrations -database "postgres://..." down
```

## Safe Migration Patterns

### Adding Columns

```sql
-- Safe: Allow NULL initially
ALTER TABLE users ADD COLUMN email VARCHAR(255);

-- Backfill data
UPDATE users SET email = CONCAT(id, '@placeholder.com') 
WHERE email IS NULL;

-- Then add constraint if needed
ALTER TABLE users ALTER COLUMN email SET NOT NULL;
```

### Removing Columns

```sql
-- Step 1: Stop writing to column (code change)
-- Step 2: Deploy code
-- Step 3: Remove column (migration)
ALTER TABLE users DROP COLUMN old_column;
```

### Renaming Columns

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN new_email VARCHAR(255);

-- Step 2: Copy data
UPDATE users SET new_email = old_email;

-- Step 3: Update code to use new column
-- Step 4: Deploy code
-- Step 5: Drop old column
ALTER TABLE users DROP COLUMN old_email;
```

### Changing Column Types

```sql
-- Step 1: Add new column with new type
ALTER TABLE users ADD COLUMN new_age INTEGER;

-- Step 2: Convert and copy data
UPDATE users SET new_age = CAST(old_age AS INTEGER);

-- Step 3: Update code
-- Step 4: Deploy code
-- Step 5: Drop old column
ALTER TABLE users DROP COLUMN old_age;
```

## Data Migrations

### Best Practices

1. **Batch large updates** - Don't lock tables for long
2. **Test with production-like data** - Volume matters
3. **Have rollback plan** - Can you restore data?
4. **Monitor during execution** - Watch for issues

### Example: Batch Update

```python
# Bad: Single large update
UPDATE users SET status = 'active' WHERE last_login > '2023-01-01';

# Good: Batched update
batch_size = 1000
offset = 0
while True:
    updated = execute("""
        UPDATE users 
        SET status = 'active' 
        WHERE last_login > '2023-01-01'
        LIMIT %s OFFSET %s
    """, batch_size, offset)
    
    if updated < batch_size:
        break
    offset += batch_size
```

## Rollback Procedures

### Before Migration

1. **Backup database**
   ```bash
   pg_dump mydb > backup_$(date +%Y%m%d).sql
   ```

2. **Test rollback on staging**
   ```bash
   # Apply
   migrate up
   
   # Verify
   # ... run tests ...
   
   # Rollback
   migrate down
   
   # Verify data intact
   ```

3. **Document rollback steps**
   ```markdown
   Rollback Procedure:
   1. Run: migrate down
   2. Verify: SELECT count(*) FROM users
   3. If failed: Restore from backup
   ```

### During Migration Issues

```bash
# Stop migration if running
Ctrl+C

# Check migration status
migrate status

# Force rollback if needed
migrate force <previous_version>

# Restore from backup if critical
psql mydb < backup.sql
```

## Production Deployment

### Pre-Deployment Checklist

- [ ] Migration tested on staging
- [ ] Rollback tested and documented
- [ ] Backup completed
- [ ] Maintenance window scheduled (if needed)
- [ ] Team notified
- [ ] Monitoring enabled

### Deployment Steps

```bash
# 1. Create backup
pg_dump -h prod -U user mydb | gzip > backup.sql.gz

# 2. Run migration
migrate -path migrations -database "$PROD_URL" up

# 3. Verify
psql -h prod -U user mydb -c "SELECT version FROM schema_migrations"

# 4. Monitor
# Watch error rates, latency, etc.
```

### Post-Deployment

- [ ] Verify application works
- [ ] Check error logs
- [ ] Monitor performance
- [ ] Confirm backup can be removed (after safe period)

## Common Issues

### Lock Timeouts

```sql
-- Problem: Long-running migration holds lock
ALTER TABLE large_table ADD COLUMN new_col TEXT;

-- Solution: Use lock_timeout
SET lock_timeout = '1min';
ALTER TABLE large_table ADD COLUMN new_col TEXT;
-- If times out, retry during low-traffic period
```

### Disk Space

```bash
# Check space before migration
df -h

# Monitor during migration
watch -n 5 'df -h'

# Clean up if needed
VACUUM FULL;  # PostgreSQL
OPTIMIZE TABLE;  # MySQL
```

### Replication Lag

- Run migrations on primary first
- Wait for replica sync
- Verify replicas caught up
- Update read replicas configuration

## Monitoring

### During Migration

```sql
-- PostgreSQL: Check progress
SELECT pid, now() - pg_stat_activity.query_start AS duration, query
FROM pg_stat_activity
WHERE state = 'active';

-- MySQL: Check progress
SHOW PROCESSLIST;
```

### After Migration

```sql
-- Verify table structure
\d users  -- PostgreSQL
DESCRIBE users;  -- MySQL

-- Check row counts
SELECT count(*) FROM users;

-- Verify indexes
SELECT indexname FROM pg_indexes WHERE tablename = 'users';
```
