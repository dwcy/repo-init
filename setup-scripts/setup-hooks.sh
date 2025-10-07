#!/bin/bash
# Setup script to install git hooks
# This script copies the hooks from git-hooks subdirectories to .git/hooks

echo "Setting up git hooks..."

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
GIT_HOOKS_DIR=".git/hooks"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository. Please run this script from the project root."
    exit 1
fi

# Create .git/hooks directory if it doesn't exist
mkdir -p "$GIT_HOOKS_DIR"

# Define hook mappings: source directory -> hook files
declare -A HOOK_MAPPINGS
HOOK_MAPPINGS["git-hooks/conventional-commit-msg"]="commit-msg"
HOOK_MAPPINGS["git-hooks/dotnet-format-pre-commit"]="pre-commit pre-commit.ps1"
HOOK_MAPPINGS["git-hooks/run-tests-before-push"]="pre-push pre-push.ps1"

# Copy hook files from their respective directories
for hook_dir in "${!HOOK_MAPPINGS[@]}"; do
    source_dir="$PROJECT_ROOT/$hook_dir"
    hook_files="${HOOK_MAPPINGS[$hook_dir]}"
    
    for hook_file in $hook_files; do
        source_path="$source_dir/$hook_file"
        dest_path="$GIT_HOOKS_DIR/$hook_file"
        
        if [ -f "$source_path" ]; then
            cp "$source_path" "$dest_path"
            echo "Installed: $hook_file"
        else
            echo "Warning: $hook_file not found in $source_dir"
        fi
    done
done

# Make the shell scripts executable
SHELL_HOOKS=("commit-msg" "pre-commit" "pre-push")
for hook in "${SHELL_HOOKS[@]}"; do
    hook_path="$GIT_HOOKS_DIR/$hook"
    if [ -f "$hook_path" ]; then
        chmod +x "$hook_path"
    fi
done

echo "Git hooks setup complete!"
echo "Hooks installed:"
echo "  - commit-msg: Validates conventional commit messages"
echo "  - pre-commit: Runs 'dotnet format' before commits"
echo "  - pre-push: Runs 'dotnet test' before pushes"
echo ""
echo "To bypass hooks, use:"
echo "  git commit --no-verify"
echo "  git push --no-verify"
