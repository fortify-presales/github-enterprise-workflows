param(
    [Parameter(Mandatory = $false)]
    [string]$RootPath = "."
)

$ErrorActionPreference = "Stop"
$workflowFiles = Get-ChildItem -Path $RootPath -Recurse -File -Include *.yml,*.yaml |
    Where-Object { $_.FullName -match "\\.github\\workflows\\" }

if (-not $workflowFiles) {
    Write-Host "No workflow files found."
    exit 0
}

$violations = @()
foreach ($file in $workflowFiles) {
    $content = Get-Content -Path $file.FullName -Raw

    if ($content -match "uses:\s*fortify-presales/platform-workflows/.+@main") {
        $violations += "Disallowed @main reference in $($file.FullName)"
    }

    if ($content -notmatch "fortify-presales/platform-workflows/.github/workflows/reusable-fortify-fod.yml@v1") {
        $violations += "Missing required Fortify reusable workflow ref: $($file.FullName)"
    }

    if ($content -notmatch "fortify-presales/platform-workflows/.github/workflows/reusable-sonatype-sca.yml@v1") {
        $violations += "Missing required Sonatype reusable workflow ref: $($file.FullName)"
    }
}

if ($violations.Count -gt 0) {
    Write-Host "Compliance violations found:"
    $violations | ForEach-Object { Write-Host "- $_" }
    exit 1
}

Write-Host "Compliance checks passed."
exit 0
