# Repository Initialization Toolkit

A comprehensive toolkit for setting up professional .NET development environments with automated git hooks, code formatting, testing, and style enforcement.

## 🚀 Features

- **Automated Git Hooks**: Pre-commit formatting and pre-push testing
- **Conventional Commits**: Enforced commit message standards
- **Code Quality**: Comprehensive .NET style enforcement
- **Cross-Platform**: PowerShell and Bash setup scripts
- **Professional Standards**: Industry best practices out of the box

## 📁 Project Structure

```
├── git-hooks/                    # Git hook implementations
│   ├── conventional-commit-msg/  # Commit message validation
│   ├── dotnet-format-pre-commit/ # Code formatting hooks
│   └── run-tests-before-push/    # Test execution hooks
├── setup-scripts/               # Installation scripts
│   ├── setup-hooks.ps1         # PowerShell setup
│   └── setup-hooks.sh          # Bash setup
├── editor-config/              # Editor configuration
│   └── .editorconfig           # Comprehensive C# style rules
├── git-rules/                  # Git configuration templates
│   ├── .gitattributes         # Git attributes
│   └── .gitignore             # Git ignore patterns
└── docs/                      # Documentation
```

## 🛠️ Quick Start

### 1. Clone and Setup

```bash
# Clone this repository
git clone <your-repo-url>
cd repo-init

# Run the setup script (choose your platform)
# For Windows (PowerShell)
.\setup-scripts\setup-hooks.ps1

# For Unix/Linux/macOS (Bash)
bash setup-scripts/setup-hooks.sh
```

### 2. Copy Configuration Files

```bash
# Copy editor configuration
cp editor-config/.editorconfig ./

# Copy git configuration
cp git-rules/.gitattributes ./
cp git-rules/.gitignore ./
```

## 🔧 Git Hooks

### Pre-commit Hook
Automatically formats your C# code using `dotnet format` before each commit.

**Features:**
- Detects .NET projects automatically
- Formats staged files only
- Cross-platform support (Windows PowerShell + Unix shell)
- Prevents commits with unformatted code

### Pre-push Hook
Runs `dotnet test` before pushing to ensure all tests pass.

**Features:**
- Automatically detects test projects
- Runs tests on solution or individual projects
- Prevents pushing broken code
- Cross-platform support

### Commit Message Hook
Enforces [Conventional Commits](https://www.conventionalcommits.org/) standard.

**Format:**
```
<type>(<scope>): <description>
```

**Valid Types:**
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `build`: Build system changes
- `ci`: CI/CD changes
- `perf`: Performance improvements
- `revert`: Reverting changes

**Examples:**
```bash
feat: add user authentication
fix(api): resolve null reference exception
docs: update installation guide
feat(auth): implement OAuth2 integration
```

## 📝 Editor Configuration

The included `.editorconfig` provides comprehensive C# style enforcement:

### Key Features:
- **Allman Style**: Opening braces on new lines
- **File-scoped Namespaces**: Modern C# namespace declarations
- **Comprehensive Diagnostics**: 200+ code analysis rules
- **xUnit Support**: Test framework best practices
- **Security Rules**: CA and security diagnostic enforcement
- **Modern C#**: Latest language feature preferences

### Style Highlights:
- Maximum line length: 144 characters
- 4-space indentation for C#
- UTF-8 encoding with LF line endings
- Comprehensive naming conventions
- Expression-bodied member preferences

## 🎯 Usage Examples

### Bypassing Hooks (When Necessary)
```bash
# Skip pre-commit hook
git commit --no-verify -m "fix: emergency hotfix"

# Skip pre-push hook
git push --no-verify
```

### Customizing Hooks
The hooks are designed to be easily customizable. Edit the files in `git-hooks/` directories to modify behavior.

### IDE Integration
The `.editorconfig` works with:
- Visual Studio
- Visual Studio Code
- JetBrains Rider
- Any editor with EditorConfig support

## 🔍 Troubleshooting

### Common Issues

**Hook not executing:**
```bash
# Make sure hooks are executable (Unix)
chmod +x .git/hooks/*
```

**PowerShell execution policy (Windows):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Missing .NET SDK:**
```bash
# Install .NET SDK from https://dotnet.microsoft.com/download
dotnet --version
```

### Debugging Hooks
```bash
# Run hooks manually to debug
.git/hooks/pre-commit
.git/hooks/pre-push
.git/hooks/commit-msg
```

## 📋 Requirements

- **Git**: Version 2.0 or later
- **.NET SDK**: 6.0 or later (for formatting and testing)
- **PowerShell**: 5.1+ (Windows) or PowerShell Core (cross-platform)
- **Bash**: Available on Unix-like systems

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is released into the public domain under the [Unlicense](LICENSE).

## 🙏 Acknowledgments

- [Conventional Commits](https://www.conventionalcommits.org/) for commit message standards
- [EditorConfig](https://editorconfig.org/) for cross-editor configuration
- [.NET](https://dotnet.microsoft.com/) for the development platform
- [xUnit](https://xunit.net/) for testing framework

---

**Happy Coding!** 🎉
