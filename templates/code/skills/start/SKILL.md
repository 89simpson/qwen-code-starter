---
name: start
description: Project initialization and setup procedures
---

# Start Skill

## Purpose

Initialize new projects or features with proper structure, configuration, and boilerplate.

## When to Use

- Starting a new project from scratch
- Adding a new feature or module
- Setting up development environment
- Creating new service or application

## Procedures

### New Project Setup

1. **Determine Project Type**
   - Code project (application, library, service)
   - Content project (documentation, tutorials)
   - Hybrid (both code and content)

2. **Initialize Structure**
   ```bash
   # Create directory structure
   mkdir -p src tests docs
   
   # Initialize version control
   git init
   
   # Initialize package manager
   npm init -y    # Node.js
   poetry init    # Python
   go mod init    # Go
   ```

3. **Add Essential Files**
   - README.md
   - LICENSE
   - .gitignore
   - QWEN.md (project passport)
   - Configuration files

4. **Set Up Development Environment**
   - Install dependencies
   - Configure linters
   - Set up test framework
   - Create initial test

### New Feature Setup

1. **Understand Requirements**
   - What problem does this solve?
   - What are the acceptance criteria?
   - Any constraints or dependencies?

2. **Plan Implementation**
   - Files to create/modify
   - Dependencies to add
   - Tests to write
   - Documentation needed

3. **Create Feature Branch**
   ```bash
   git checkout -b feat/feature-name
   ```

4. **Implement Incrementally**
   - Start with tests (TDD)
   - Implement minimum viable solution
   - Refactor and improve
   - Add documentation

## Checklists

### Project Initialization Checklist

- [ ] Directory structure created
- [ ] Version control initialized
- [ ] Package manager configured
- [ ] QWEN.md created
- [ ] README.md with basic info
- [ ] .gitignore configured
- [ ] License added
- [ ] CI/CD pipeline (if applicable)
- [ ] Development documentation

### Feature Initialization Checklist

- [ ] Requirements understood
- [ ] Implementation plan defined
- [ ] Feature branch created
- [ ] Test files created
- [ ] Source files created
- [ ] Initial implementation complete
- [ ] Tests passing
- [ ] Documentation updated

## Templates

### README Template

```markdown
# Project Name

Brief description of the project.

## Installation

```bash
npm install
# or
pip install -r requirements.txt
```

## Usage

```bash
npm start
# or
python -m package_name
```

## Development

```bash
npm test
npm run lint
```

## License

MIT
```

### QWEN.md Template

Use the framework template:
```bash
cp templates/code/QWEN.md ./QWEN.md
# Edit for project specifics
```

## Common Setups

### Node.js Project

```bash
npm init -y
npm install --save-dev jest eslint prettier
mkdir -p src tests
```

### Python Project

```bash
poetry init
poetry add --group dev pytest black flake8
mkdir -p src tests
```

### Go Project

```bash
go mod init module-name
go get -d github.com/stretchr/testify
mkdir -p cmd pkg internal
```

## Post-Setup Verification

1. **Build Verification**
   ```bash
   npm run build  # or equivalent
   ```

2. **Test Verification**
   ```bash
   npm test  # Should pass (even if empty)
   ```

3. **Lint Verification**
   ```bash
   npm run lint  # Should pass
   ```

4. **Documentation Check**
   - README is readable
   - QWEN.md has project info
   - Setup instructions work

## Troubleshooting

### Common Issues

**Dependencies won't install**
- Check Node/Python version
- Clear cache: `npm cache clean` or `poetry cache clear`
- Check network/proxy settings

**Tests won't run**
- Verify test framework configuration
- Check test file naming conventions
- Ensure test dependencies installed

**Linting fails on empty project**
- Create placeholder files
- Adjust linting rules for new project
- Add eslint-ignore or similar

## Next Steps

After initialization:
1. Implement core functionality
2. Add comprehensive tests
3. Set up CI/CD
4. Write detailed documentation
5. Configure deployment
