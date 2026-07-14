param(
    [Parameter(Mandatory = $false)]
    [string]$Org = "fortify-presales",

    [Parameter(Mandatory = $false)]
    [string]$SourceRef = "main",

    [Parameter(Mandatory = $false)]
    [string]$RepoHost = "github.com",

    [Parameter(Mandatory = $false)]
    [switch]$UseHttps,

    [Parameter(Mandatory = $false)]
    [string]$Pat,

    [Parameter(Mandatory = $false)]
    [switch]$IncludeExamples,

    [Parameter(Mandatory = $false)]
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Assert-CommandExists {
    param([string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)] [string[]]$Args)

    # Native git commands often emit progress on stderr even when successful.
    # Temporarily relax error action to avoid treating stderr text as a fatal PowerShell error.
    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"

    try {
        $output = & git @Args 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    if ($exitCode -ne 0) {
        throw "git $($Args -join ' ') failed. Output: $output"
    }

    return $output
}

function Get-RepoUrl {
    param(
        [string]$GitServer,
        [string]$Organization,
        [string]$Repository,
        [bool]$Https,
        [string]$Token
    )

    if ($Https) {
        if ([string]::IsNullOrWhiteSpace($Token)) {
            return "https://$GitServer/$Organization/$Repository.git"
        }

        return "https://x-access-token:$Token@$GitServer/$Organization/$Repository.git"
    }

    return "git@$GitServer`:$Organization/$Repository.git"
}

Assert-CommandExists -Name git

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    $inside = Invoke-Git rev-parse --is-inside-work-tree
    if (-not ($inside -join "") -match "true") {
        throw "Current folder is not a git repository."
    }

    Invoke-Git fetch --all --prune | Out-Null

    $mappings = @(
        @{ Prefix = "platform-workflows"; Repo = "platform-workflows" },
        @{ Prefix = "platform-actions"; Repo = "platform-actions" },
        @{ Prefix = "platform-governance"; Repo = "platform-governance" },
        @{ Prefix = "platform-docs"; Repo = "platform-docs" }
    )

    if ($IncludeExamples) {
        $mappings += @{ Prefix = "examples/ref-app-monorepo"; Repo = "ref-app-monorepo" }
        $mappings += @{ Prefix = "examples/ref-app-java"; Repo = "ref-app-java" }
        $mappings += @{ Prefix = "examples/ref-app-node"; Repo = "ref-app-node" }
        $mappings += @{ Prefix = "examples/ref-app-python"; Repo = "ref-app-python" }
        $mappings += @{ Prefix = "examples/ref-app-dotnet"; Repo = "ref-app-dotnet" }
    }

    $stamp = Get-Date -Format "yyyyMMddHHmmss"

    foreach ($mapping in $mappings) {
        $prefix = $mapping.Prefix
        $repo = $mapping.Repo
        $splitBranch = "split/$repo-$stamp"

        if (-not (Test-Path (Join-Path $repoRoot $prefix))) {
            Write-Host "Skipping missing prefix: $prefix"
            continue
        }

        $repoUrl = Get-RepoUrl -GitServer $RepoHost -Organization $Org -Repository $repo -Https:$UseHttps.IsPresent -Token $Pat

        Write-Host "---"
        Write-Host "Publishing prefix '$prefix' to '$Org/$repo'"
        Write-Host "Source ref: $SourceRef"

        if ($DryRun) {
            Write-Host "[DryRun] git subtree split --prefix=$prefix --branch $splitBranch $SourceRef"
            Write-Host "[DryRun] git push $repoUrl $($splitBranch):main --force"
            continue
        }

        Invoke-Git subtree split --prefix=$prefix --branch $splitBranch $SourceRef | Out-Null
        Invoke-Git push $repoUrl "$splitBranch`:main" --force | Out-Null
        Invoke-Git branch -D $splitBranch | Out-Null

        Write-Host "Published '$prefix' to '$Org/$repo:main'"
    }

    Write-Host "---"
    Write-Host "Publish process complete."
}
finally {
    Pop-Location
}
