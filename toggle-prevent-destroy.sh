#!/bin/bash

# Toggle Prevent Destroy Script
# This script helps toggle the prevent_destroy setting in all Terraform lifecycle blocks

if [ $# -eq 0 ]; then
    echo "Usage: $0 [true|false]"
    echo "Example: $0 false"
    exit 1
fi

PREVENT_DESTROY=$1

if [[ "$PREVENT_DESTROY" != "true" && "$PREVENT_DESTROY" != "false" ]]; then
    echo "Error: Value must be 'true' or 'false'"
    exit 1
fi

echo "Setting prevent_destroy = $PREVENT_DESTROY for all resources..."

# Function to update prevent_destroy in files
update_prevent_destroy() {
    local file_path=$1
    local new_value=$2
    
    if [ -f "$file_path" ]; then
        sed -i.bak "s/prevent_destroy = \(true\|false\)/prevent_destroy = $new_value/g" "$file_path"
        rm "${file_path}.bak" 2>/dev/null || true
        echo "Updated: $file_path"
    fi
}

# List of files to update
files_to_update=(
    "main.tf"
    "AZURE/azure_cluster.tf"
    "AZURE/azure_flink.tf"
    "AZURE/sample_project/topics.tf"
    "AZURE/sample_project/http_source_connector.tf"
)

# Update each file
for file in "${files_to_update[@]}"; do
    update_prevent_destroy "$file" "$PREVENT_DESTROY"
done

echo ""
echo "Completed! All resources now have prevent_destroy = $PREVENT_DESTROY"
echo "Remember to run 'terraform plan' to review changes before applying."
