#!/bin/bash

# This script builds the app in release mode for a single configuration and uploads it to TestFlight

# Function to display usage information
usage() {
  echo "Usage: $0 --project-root <absolute_path_to_project_root>"
  exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

# Check if project_root is set
if [[ -z "$project_root" ]]; then
  echo "Error: --project-root argument is required."
  usage
fi

# Change to the root directory of the project to read the versions
cd "$project_root" || exit

# Source the versions file found at <project-root>/versions
source ./versions

# Change to the directory of the script to read the required files
cd "$(dirname "$0")" || exit

# Ensure required parameters are set
if [[ -z "$ios_version_name" || -z "$ios_build_number" ]]; then
  echo "Missing required version information in versions file."
  exit 1
fi

# Read the API key and issuer ID
api_key=$(cat ./api_key_name)
issuer_id=$(cat ./issuer_id)

# Function to build and upload IPA
build_and_upload() {
  # Change to project root
  cd "$project_root" || exit

  # Build command targeting main.dart
  build_command="
  flutter build ipa \
    --release \
    --build-name=$ios_version_name \
    --build-number=$ios_build_number \
    -t lib/main.dart
  "
  echo "Running command: $build_command"
  eval "$build_command"

  # Upload command
  upload_command="
  xcrun altool --upload-app --type ios \
    -f build/ios/ipa/*.ipa \
    --apiKey $api_key \
    --apiIssuer $issuer_id
  "
  echo "Running command: $upload_command"
  eval "$upload_command"
}

# Upload the build for main.dart
build_and_upload