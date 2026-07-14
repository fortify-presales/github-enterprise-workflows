param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ref-app-java", "ref-app-node", "ref-app-python", "ref-app-dotnet", "ref-app-monorepo")]
    [string]$TemplateName,

    [Parameter(Mandatory = $true)]
    [string]$DestinationPath,

    [Parameter(Mandatory = $false)]
    [string]$NewName
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $repoRoot (Join-Path "examples" $TemplateName)

if (-not (Test-Path $templatePath)) {
    throw "Template path not found: $templatePath"
}

if (-not $NewName) {
    $NewName = Split-Path -Leaf $DestinationPath
}

if (Test-Path $DestinationPath) {
    throw "Destination already exists: $DestinationPath"
}

Write-Host "Creating new example from template '$TemplateName'..."
Copy-Item -Path $templatePath -Destination $DestinationPath -Recurse

$replaceExtensions = @(
    "*.md", "*.txt", "*.yml", "*.yaml", "*.json", "*.toml", "*.xml", "*.csproj", "*.props",
    "*.js", "*.ts", "*.py", "*.java", "*.cs", "*.ps1", "*.sh"
)

$files = Get-ChildItem -Path $DestinationPath -Recurse -File -Include $replaceExtensions
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $updated = $content.Replace($TemplateName, $NewName)
    if ($updated -ne $content) {
        Set-Content -Path $file.FullName -Value $updated -NoNewline
    }
}

Write-Host "Created: $DestinationPath"
Write-Host "Template name replacements completed: $TemplateName -> $NewName"
Write-Host "Next steps:"
Write-Host "1. Initialize git in the destination folder"
Write-Host "2. Configure repository variables and secrets"
Write-Host "3. Push and trigger .github/workflows/security.yml"
