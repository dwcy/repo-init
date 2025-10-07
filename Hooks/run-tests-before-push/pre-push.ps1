# Pre-push hook that runs dotnet test before pushing
# PowerShell version for Windows

Write-Host "Running dotnet test before push..." -ForegroundColor Blue

# Check if dotnet is available
try {
    $dotnetVersion = dotnet --version
    Write-Host "Using .NET version: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "Error: dotnet command not found. Please install .NET SDK." -ForegroundColor Red
    exit 1
}

# Find test projects by looking for test-related packages in .csproj files
$testProjects = @()
$allProjects = Get-ChildItem -Path . -Filter "*.csproj" -Recurse | Where-Object { 
    $_.FullName -notmatch '\.git' -and 
    $_.FullName -notmatch 'node_modules' -and 
    $_.FullName -notmatch '\\bin\\' -and 
    $_.FullName -notmatch '\\obj\\'
}

foreach ($project in $allProjects) {
    $content = Get-Content $project.FullName -Raw
    if ($content -match 'Microsoft\.NET\.Test\.Sdk|xunit|nunit|mstest') {
        $testProjects += $project.FullName
    }
}

if ($testProjects.Count -eq 0) {
    Write-Host "Warning: No test projects found. Looking for solution files..." -ForegroundColor Yellow
    
    # Find solution files and run tests on them
    $solutionFiles = Get-ChildItem -Path . -Filter "*.sln" -Recurse | Where-Object { 
        $_.FullName -notmatch '\.git' -and 
        $_.FullName -notmatch 'node_modules' -and 
        $_.FullName -notmatch '\\bin\\' -and 
        $_.FullName -notmatch '\\obj\\'
    } | Select-Object -ExpandProperty FullName
    
    if ($solutionFiles.Count -eq 0) {
        Write-Host "No solution files found. Running dotnet test on all projects..." -ForegroundColor Yellow
        $result = dotnet test --verbosity quiet --no-build
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Tests failed!" -ForegroundColor Red
            exit 1
        }
    } else {
        # Run tests on solution files
        foreach ($solution in $solutionFiles) {
            Write-Host "Running tests for solution: $solution" -ForegroundColor Blue
            $result = dotnet test $solution --verbosity quiet --no-build
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Error: Tests failed for $solution" -ForegroundColor Red
                exit 1
                exit 1
            }
        }
    }
} else {
    # Run tests on individual test projects
    foreach ($project in $testProjects) {
        Write-Host "Running tests for project: $project" -ForegroundColor Blue
        $result = dotnet test $project --verbosity quiet --no-build
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Tests failed for $project" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host "All tests passed! Proceeding with push..." -ForegroundColor Green
exit 0
