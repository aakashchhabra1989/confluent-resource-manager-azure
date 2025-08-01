# Toggle Prevent Destroy Script
# This script helps toggle the prevent_destroy setting in all Terraform lifecycle blocks

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("true", "false")]
    [string]$PreventDestroy
)

Write-Host "Setting prevent_destroy = $PreventDestroy for all resources..." -ForegroundColor Yellow

# Function to update prevent_destroy in files
function Update-PreventDestroy {
    param(
        [string]$FilePath,
        [string]$NewValue
    )
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw
        $updatedContent = $content -replace 'prevent_destroy = (true|false)', "prevent_destroy = $NewValue"
        Set-Content -Path $FilePath -Value $updatedContent -NoNewline
        Write-Host "Updated: $FilePath" -ForegroundColor Green
    }
}

# List of files to update
$filesToUpdate = @(
    "main.tf",
    "AZURE\azure_cluster.tf",
    "AZURE\azure_flink.tf",
    "AZURE\sample_project\topics.tf",
    "AZURE\sample_project\http_source_connector.tf"
)

# Update each file
foreach ($file in $filesToUpdate) {
    $fullPath = Join-Path $PSScriptRoot $file
    Update-PreventDestroy -FilePath $fullPath -NewValue $PreventDestroy
}

Write-Host "`nCompleted! All resources now have prevent_destroy = $PreventDestroy" -ForegroundColor Cyan
Write-Host "Remember to run 'terraform plan' to review changes before applying." -ForegroundColor Yellow
