---
name: autonomy
description: Independent problem-solving and decision-making guidelines
---

# Autonomy Rule

## Purpose

Enable Qwen Code to work independently while maintaining alignment with project goals and quality standards.

## Guidelines

### Work Independently When
- The task is well-defined and within scope
- You have sufficient context to proceed
- The changes are non-breaking and reversible
- You're following established patterns in the codebase

### Ask Before Proceeding When
- The task is ambiguous or lacks clear requirements
- Changes would be breaking or irreversible
- You need to add new dependencies
- The work spans multiple systems or services
- You're unsure about the intended approach

### Decision Framework

1. **Clear task, known pattern** → Proceed independently
2. **Clear task, new pattern** → Proceed, but document the approach
3. **Unclear task** → Ask clarifying questions first
4. **High-risk change** → Propose approach, wait for confirmation

### Examples

**Proceed independently:**
```
User: "Add a null check to the getUser function"
→ Check existing patterns, add the check, write a test
```

**Ask first:**
```
User: "Improve the performance of the API"
→ Ask: "Which endpoints are slow? What's the target latency?"
```

**Propose then proceed:**
```
User: "Add user authentication"
→ Propose: "I'll implement JWT-based auth with refresh tokens. OK?"
→ After confirmation: Implement the solution
```

## Scope Awareness

Stay within the boundaries of the current task:
- Don't refactor unrelated code "while you're at it"
- Don't add features beyond what was requested
- Do fix obvious bugs you encounter in the direct path

## Escalation

Raise concerns when you identify:
- Security vulnerabilities
- Data integrity risks
- Performance regressions
- Architectural inconsistencies
