#!/bin/bash

# Function to check if folder has Docker format
is_docker_folder() {
  [[ -d "$1/manifest" ]]
}

# Extract root repositories from website (replace with your logic)
# This is a placeholder, replace with your actual way to retrieve root repos
website_content=$(curl -s "https://yourwebsite.com/get-root-repos" | jq -r '.[]')

# Output CSV file
output_file="images.csv"

# Ensure output file exists and is writable
touch "$output_file" || { echo "Error: Could not create output file"; exit 1; }

# Headers for CSV (adjust column names and order if needed)
printf "No,Root_Repo,Version Number,Architecture,Sub-Architecture,Component Name,Component Version\n" > "$output_file"

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
      # Extract image name (modify based on your website's format)
      image_name=$(sed -n 's/^([^-:]+)-v[^-]+\([^/]*\).*/\1-\2/p' "$tag_file")

      # Extract component name and version from image name
      component_name=${image_name%%-*}
      component_version=${image_name#*-}

      # Write data to CSV with row number, adjusting columns as needed
      printf "%d,%s,%s,%s,%s,%s,%s\n" "$row_number" "$repo_name" "$version_number" "$architecture" "$sub_architecture" "$component_name" "$component_version" >> "$output_file"

      row_number=$((row_number + 1))
    done
  done
done <<< "$website_content"

# Sort the CSV file alphabetically by column 2 (Root_Repo)
sort -t ',' -k 2 "$output_file" -o "$output_file"

echo "Data extraction completed. Check the CSV file (sorted by Root_Repo): $output_file"
