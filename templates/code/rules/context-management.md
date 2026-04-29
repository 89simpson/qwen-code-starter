---
name: context-management
description: Strategies for managing context window efficiently
---

# Context Management Rule

## Purpose

Maximize effectiveness within context window limits by strategically managing what information is included in conversations.

## Context Window Awareness

### Know the Limits
- Context windows are finite
- Every token counts
- Old context gets compressed or dropped

### Monitor Context Usage
- Be aware of conversation length
- Recognize when context is getting full
- Proactively manage before hitting limits

## Strategies

### 1. Reference, Don't Include

**Instead of:**
```
[Pastes entire 500-line file]
```

**Do:**
```
See: src/services/userService.ts
Key function: getUserById (lines 45-89)
```

### 2. Use File Paths

Reference files by path when Qwen Code can read them:
```
Configuration: config/database.yml
Tests: tests/unit/test_auth.py
Models: src/models/User.ts
```

### 3. Summarize Long Discussions

When a thread gets long:
```
Summary so far:
- Decided to use JWT for auth
- Implemented login endpoint
- Next: Add refresh token logic
```

### 4. Close Completed Topics

Mark completed work as done:
```
[Completed] Database schema design
[In Progress] API implementation
[Pending] Frontend integration
```

## Reading Files

### Efficient File Reading
- Read only what you need
- Use line ranges for large files
- Read multiple files in parallel when possible

### When to Read
- Before making changes (understand context)
- When user references specific code
- When debugging or investigating issues

### When NOT to Read
- Files you've recently read (use memory)
- Files irrelevant to current task
- Entire directories "just to understand"

## Writing Files

### Focused Changes
- Modify only necessary sections
- Preserve surrounding code
- Don't reformat unrelated code

### Incremental Updates
- Small, testable changes
- Commit-worthy chunks
- Clear change boundaries

## Context Compression

### What Gets Compressed
- Early conversation turns
- Detailed code listings
- Extended reasoning traces

### What Stays Sharp
- Recent exchanges
- Explicitly referenced items
- User's stated preferences

## Best Practices

### Start Fresh When
- Switching to a new topic
- After completing a major task
- When context is getting full

### Maintain Continuity With
- Brief summaries of relevant history
- References to key decisions
- Links to important files

### Use Tools Effectively
- `read_file` for specific content
- `edit` for targeted changes
- `write_file` for new content
- Avoid pasting large content in messages

## Example Scenarios

### Good Context Management
```
User: "Fix the bug in the login function"
Agent: [Reads src/auth/login.ts lines 20-50]
      [Identifies issue]
      [Makes targeted fix]
```

### Poor Context Management
```
User: "Fix the bug in the login function"
Agent: "Let me look at all auth files..."
      [Reads 10 files, 2000+ lines]
      [Context nearly full before starting]
```

## Recovery Strategies

When context is running low:
1. Summarize key points
2. Reference files instead of including content
3. Suggest continuing in a fresh conversation
4. Save important state to files
