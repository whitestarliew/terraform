#!/bin/bash

# Function to check if folder has Docker format
is_docker_folder() {
  [[ -d "$1/manifest" ]]
}

# Extract root repositories from website (replace with your logic)
# This is a placeholder, replace with your actual way to retrieve root repos
website_content=$(curl -s "https://yourwebsite.com/get-root-repos" | jq -r '.[]')

# Output CSV file
output_file="image_summary.csv"

# Ensure output file exists and is writable
touch "$output_file" || { echo "Error: Could not create output file"; exit 1; }

# Headers for CSV (adjust column names and order if needed)
printf "No,Repository,Format,Component_Name,Component_Version,Path,Content_Type,File_Size\n" > "$output_file"

# Counter for row numbering
row_number=1

# Loop through each root repository entry in the website content
while IFS=':' read -r repo_path version_url; do
  # Skip lines without both components
  [[ -n "$repo_path" && -n "$version_url" ]] || continue

  # Extract repository name and version
  repo_name="${repo_path%/*}"
  version_number="${repo_path##*/}"

  # Download and process version data
  version_data=$(curl -s "$version_url")

  # Loop through architecture entries in the version data
  while IFS=',' read -r arch_folder tags_url; do
    # Skip lines without both components
    [[ -n "$arch_folder" && -n "$tags_url" ]] || continue

    # Extract architecture and sub-architecture (if present)
    arch_parts=(${arch_folder##*/})
    architecture=${arch_parts[0]}
    sub_architecture=${arch_parts[1]-}  # Optional: Capture sub-architecture if exists

    # Download and loop through tags
    tags_list=$(curl -s "$tags_url")
    for tag_file in $(echo "$tags_list"); do
      # Extract tag name
      tag_name="${tag_file##*/}"

      # Construct tag file path
      tag_file_path="$repo_path/$version_number/$arch_folder/tags/$tag_file"

      # Check if Docker format based on "manifest" presence
      if is_docker_folder "$tag_file_path"; then
        # Extract component details (modify based on tag file format)
        # Example: assuming component details are in a YAML file within the tag
        component_details_file="$tag_file_path/component-details.yaml"
        if [[ -f "$component_details_file" ]]; then
          component_name=$(yq -r '.component_name' "$component_details_file")
          component_version=$(yq -r '.component_version' "$component_details_file")
        else
          # Fallback logic if component details file is missing
          component_name="${tag_name%-*}"  # Assuming format like "component-version"
          component_version="${tag_name#*[-.]}"
        fi

        # Get file size and content type
        file_size=$(stat -c %s "$tag_file_path")
        content_type=$(file -b --mime-type "$tag_file_path")

        # Write data to CSV with row number, adjusting columns as needed
        printf "%d,%s,Docker,%s,%s,%s,%s,%s\n" "$row_number" "$repo_name" "$component_name" "$component_version" "$tag_file_path" "$content_type" "$file_size" >> "$output_file"

        row_number=$((row_number + 1))
      fi.
    done
  done
done <<< "$website_content"

echo "Data extraction completed. Check the CSV file: $output_file"
