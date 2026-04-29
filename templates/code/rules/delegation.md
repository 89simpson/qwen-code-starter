---
name: delegation
description: Guidelines for delegating tasks to subagents
---

# Delegation Rule

## Purpose

Define when and how to delegate work to subagents for efficient parallel execution and specialized task handling.

## When to Delegate

### Good Candidates for Delegation

1. **Parallel Tasks**
   - Independent operations that can run concurrently
   - Multiple file operations in different directories
   - Separate analysis tasks (e.g., "analyze frontend and backend")

2. **Specialized Work**
   - Tasks requiring specific expertise (research, code review)
   - Deep dives that would clutter the main context
   - Exploratory work that may not be needed

3. **Large Scoped Tasks**
   - Work that would exceed context limits
   - Multi-step processes with clear boundaries
   - Tasks that benefit from isolated context

### When NOT to Delegate

- Simple, quick tasks (overhead not worth it)
- Tasks requiring ongoing conversation context
- Work that needs immediate user feedback
- Sequential tasks where each step depends on the previous

## Delegation Patterns

### Research Delegation
```
Delegate to researcher agent:
- Investigate best practices for [topic]
- Compare libraries: X vs Y vs Z
- Find documentation for [API/feature]
```

### Implementation Delegation
```
Delegate to implementer agent:
- Build [specific component] following [specifications]
- Refactor [module] to use [pattern]
- Implement tests for [functionality]
```

### Review Delegation
```
Delegate to reviewer agent:
- Review PR for [feature]
- Check for security vulnerabilities in [code]
- Validate test coverage for [module]
```

## Context Management

### Provide Sufficient Context
- Include relevant file paths
- Share key decisions and constraints
- Link to related discussions or documents

### Limit Context Scope
- Only share what's necessary for the task
- Avoid dumping entire codebase
- Use specific file references

## Result Integration

### Wait for Completion
- Don't proceed until subagent completes
- Handle subagent failures gracefully
- Synthesize results before responding

### Quality Check
- Verify subagent output meets requirements
- Fill in any gaps left by subagent
- Take responsibility for final output

## Example Delegation

```
User: "Research authentication options and implement the best one"

Main Agent:
1. Delegate to researcher: "Research auth options for Node.js API"
2. Wait for research results
3. Evaluate options with user
4. Delegate to implementer: "Implement JWT auth per decision"
5. Delegate to reviewer: "Review auth implementation"
6. Synthesize and deliver final result
```

## Error Handling

If a subagent fails:
1. Understand the failure reason
2. Either retry with more context or
3. Handle the task directly
4. Inform the user of the issue
