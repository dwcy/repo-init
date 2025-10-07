# Setup script to install git hooks
# This script copies the hooks from git-hooks subdirectories to .git/hooks

Write-Host "Setting up git hooks..." -ForegroundColor Green

# Get the script directory and project root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$gitHooksDir = ".git\hooks"

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "Error: Not in a git repository. Please run this script from the project root." -ForegroundColor Red
    exit 1
}

# Create .git/hooks directory if it doesn't exist
if (-not (Test-Path $gitHooksDir)) {
    New-Item -ItemType Directory -Path $gitHooksDir -Force | Out-Null
}

# Define hook mappings: source directory -> hook files
$hookMappings = @{
    "git-hooks\conventional-commit-msg" = @("commit-msg")
    "git-hooks\dotnet-format-pre-commit" = @("pre-commit", "pre-commit.ps1")
    "git-hooks\run-tests-before-push" = @("pre-push", "pre-push.ps1")
}

# Copy hook files from their respective directories
foreach ($hookDir in $hookMappings.Keys) {
    $sourceDir = Join-Path $projectRoot $hookDir
    $hookFiles = $hookMappings[$hookDir]
    
    foreach ($hookFile in $hookFiles) {
        $sourcePath = Join-Path $sourceDir $hookFile
        $destPath = Join-Path $gitHooksDir $hookFile
        
        if (Test-Path $sourcePath) {
            Copy-Item $sourcePath $destPath -Force
            Write-Host "Installed: $hookFile" -ForegroundColor Green
        } else {
            Write-Host "Warning: $hookFile not found in $sourceDir" -ForegroundColor Yellow
        }
    }
}

# Make the shell scripts executable (for Unix systems)
$shellHooks = @("commit-msg", "pre-commit", "pre-push")
foreach ($hook in $shellHooks) {
    $hookPath = Join-Path $gitHooksDir $hook
    if (Test-Path $hookPath) {
        # Try to make executable (works on Git Bash, WSL, etc.)
        try {
            & chmod +x $hookPath 2>$null
        } catch {
            # Ignore errors on Windows
        }
    }
}

Write-Host "Git hooks setup complete!" -ForegroundColor Green
Write-Host "Hooks installed:" -ForegroundColor Blue
Write-Host "  - commit-msg: Validates conventional commit messages" -ForegroundColor White
Write-Host "  - pre-commit: Runs 'dotnet format' before commits" -ForegroundColor White
Write-Host "  - pre-push: Runs 'dotnet test' before pushes" -ForegroundColor White
Write-Host ""
Write-Host "To bypass hooks, use:" -ForegroundColor Yellow
Write-Host "  git commit --no-verify" -ForegroundColor White
Write-Host "  git push --no-verify" -ForegroundColor White
