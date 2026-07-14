param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryPath,

    [Parameter(Mandatory = $false)]
    [ValidateSet("node", "python", "java", "dotnet")]
    [string]$Language,

    [Parameter(Mandatory = $false)]
    [string]$PlatformOrg = "fortify-presales",

    [Parameter(Mandatory = $false)]
    [string]$PlatformRepo = "platform-workflows",

    [Parameter(Mandatory = $false)]
    [string]$WorkflowRef = "v1",

    [Parameter(Mandatory = $false)]
    [string]$DefaultBranch = "main",

    [Parameter(Mandatory = $false)]
    [string]$SourceDir = ".",

    [Parameter(Mandatory = $false)]
    [string]$SonatypeApplicationIdVar = "LIFECYCLE_APPLICATION_ID",

    [Parameter(Mandatory = $false)]
    [string]$ScanTargets,

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Resolve-Language {
    param([string]$RepoPath)

    if (Test-Path (Join-Path $RepoPath "package.json")) {
        return "node"
    }

    if ((Test-Path (Join-Path $RepoPath "pyproject.toml")) -or (Test-Path (Join-Path $RepoPath "requirements.txt"))) {
        return "python"
    }

    if (Test-Path (Join-Path $RepoPath "pom.xml")) {
        return "java"
    }

    $hasDotnet = Get-ChildItem -Path $RepoPath -Recurse -File -Include "*.sln", "*.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($hasDotnet) {
        return "dotnet"
    }

    throw "Unable to detect language from repository files. Provide -Language explicitly (node|python|java|dotnet)."
}

function Resolve-ScanTargets {
    param(
        [string]$ResolvedLanguage,
        [string]$RepoPath,
        [string]$ExplicitTargets
    )

    if (-not [string]::IsNullOrWhiteSpace($ExplicitTargets)) {
        return $ExplicitTargets
    }

    switch ($ResolvedLanguage) {
        "node" {
            return "package.json package-lock.json"
        }
        "python" {
            return "requirements.txt pyproject.toml"
        }
        "java" {
            return "pom.xml"
        }
        "dotnet" {
            $sln = Get-ChildItem -Path $RepoPath -Recurse -File -Filter "*.sln" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($sln) {
                return $sln.FullName.Replace($RepoPath, ".").TrimStart('\\').Replace('\\', '/')
            }

            $csproj = Get-ChildItem -Path $RepoPath -Recurse -File -Filter "*.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($csproj) {
                return $csproj.FullName.Replace($RepoPath, ".").TrimStart('\\').Replace('\\', '/')
            }

            return "*.sln *.csproj"
        }
        default {
            throw "Unsupported language: $ResolvedLanguage"
        }
    }
}

if (-not (Test-Path $RepositoryPath)) {
    throw "Repository path not found: $RepositoryPath"
}

$repoFullPath = (Resolve-Path $RepositoryPath).Path

if ([string]::IsNullOrWhiteSpace($Language)) {
    $Language = Resolve-Language -RepoPath $repoFullPath
}

$resolvedTargets = Resolve-ScanTargets -ResolvedLanguage $Language -RepoPath $repoFullPath -ExplicitTargets $ScanTargets

$workflowDir = Join-Path $repoFullPath ".github\workflows"
$workflowFile = Join-Path $workflowDir "security.yml"

if ((Test-Path $workflowFile) -and -not $Force) {
    throw "Workflow already exists at $workflowFile. Re-run with -Force to overwrite."
}

if (-not (Test-Path $workflowDir)) {
    New-Item -Path $workflowDir -ItemType Directory -Force | Out-Null
}

$template = @'
name: Security

on:
    pull_request:
    push:
        branches: [__DEFAULT_BRANCH__]
    workflow_dispatch:

permissions:
    contents: read
    security-events: write
    pull-requests: write

jobs:
    fortify:
        uses: __WORKFLOW_OWNER__/__WORKFLOW_REPO__/.github/workflows/reusable-fortify-fod.yml@__WORKFLOW_REF__
        with:
            language: __LANGUAGE__
            source_dir: __SOURCE_DIR__
            build_strategy: auto
            sast_assessment_type: Static Assessment
            do_aviator_audit: false
            do_sca_scan: true
            do_check_policy: true
        secrets: inherit

    sonatype:
        uses: __WORKFLOW_OWNER__/__WORKFLOW_REPO__/.github/workflows/reusable-sonatype-sca.yml@__WORKFLOW_REF__
        with:
            application_id: ${{ vars.__SONATYPE_APP_VAR__ != '' && vars.__SONATYPE_APP_VAR__ || github.event.repository.name }}
            organization_id: ${{ vars.LIFECYCLE_ORGANIZATION_ID != '' && vars.LIFECYCLE_ORGANIZATION_ID || github.repository_owner }}
            create_application_if_missing: true
            scan_targets: __SCAN_TARGETS__
        secrets: inherit

    gate:
        needs: [fortify, sonatype]
        if: ${{ always() && !cancelled() }}
        uses: __WORKFLOW_OWNER__/__WORKFLOW_REPO__/.github/workflows/reusable-security-gate.yml@__WORKFLOW_REF__
        with:
            required_statuses_csv: >-
                Fortify=${{ needs.fortify.result }},Sonatype=${{ needs.sonatype.result }}
'@

$workflowContent = $template
$workflowContent = $workflowContent.Replace("__DEFAULT_BRANCH__", $DefaultBranch)
$workflowContent = $workflowContent.Replace("__WORKFLOW_OWNER__", $PlatformOrg)
$workflowContent = $workflowContent.Replace("__WORKFLOW_REPO__", $PlatformRepo)
$workflowContent = $workflowContent.Replace("__WORKFLOW_REF__", $WorkflowRef)
$workflowContent = $workflowContent.Replace("__LANGUAGE__", $Language)
$workflowContent = $workflowContent.Replace("__SOURCE_DIR__", $SourceDir)
$workflowContent = $workflowContent.Replace("__SONATYPE_APP_VAR__", $SonatypeApplicationIdVar)
$workflowContent = $workflowContent.Replace("__SCAN_TARGETS__", $resolvedTargets)

Set-Content -Path $workflowFile -Value $workflowContent

Write-Host "Generated $workflowFile"
Write-Host "Language: $Language"
Write-Host "Sonatype scan targets: $resolvedTargets"
Write-Host "Platform reusable workflows: $PlatformOrg/$PlatformRepo@$WorkflowRef"
