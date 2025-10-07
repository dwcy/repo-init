# Pre-commit hook that runs dotnet format on staged .NET files
# PowerShell version for Windows


# Check if dotnet is available
try {
    $null = dotnet --version
} catch {
    Write-Host "Error: dotnet command not found. Please install .NET SDK." -ForegroundColor Red
    exit 1
}

# Get the list of staged .cs files
$stagedFiles = git diff --cached --name-only --diff-filter=ACM | Where-Object { $_ -match '\.cs$' }

if (-not $stagedFiles) {
    exit 0
}

# Find the solution files in the project
$solutionFiles = Get-ChildItem -Path . -Filter "*.sln" -Recurse | Where-Object { 
    $_.FullName -notmatch '\.git' -and 
    $_.FullName -notmatch 'node_modules' -and 
    $_.FullName -notmatch '\\bin\\' -and 
    $_.FullName -notmatch '\\obj\\'
} | Select-Object -ExpandProperty FullName

if (-not $solutionFiles) {
    # Find project files
    $projectFiles = Get-ChildItem -Path . -Filter "*.csproj" -Recurse | Where-Object { 
        $_.FullName -notmatch '\.git' -and 
        $_.FullName -notmatch 'node_modules' -and 
        $_.FullName -notmatch '\\bin\\' -and 
        $_.FullName -notmatch '\\obj\\'
    } | Select-Object -ExpandProperty FullName
    
    if (-not $projectFiles) {
        Write-Host "Error: No .csproj files found." -ForegroundColor Red
        exit 1
    }
    
    # Run dotnet format on each project
    foreach ($project in $projectFiles) {
        $result = dotnet format $project --verbosity quiet 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: dotnet format failed on $project" -ForegroundColor Red
            Write-Host $result -ForegroundColor Red
            exit 1
        }
    }
} else {
    # Run dotnet format on solution files
    foreach ($solution in $solutionFiles) {
        $result = dotnet format $solution --verbosity quiet 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: dotnet format failed on $solution" -ForegroundColor Red
            Write-Host $result -ForegroundColor Red
            exit 1
        }
    }
}

# Check if any files were modified by formatting
$modifiedFiles = git diff --name-only
if ($modifiedFiles) {
    Write-Host "Error: Files were modified by dotnet format. Please stage the changes:" -ForegroundColor Red
    $modifiedFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    Write-Host ""
    Write-Host "Run 'git add .' to stage the formatted changes, or 'git commit --no-verify' to skip this check." -ForegroundColor Yellow
    exit 1
}

exit 0
