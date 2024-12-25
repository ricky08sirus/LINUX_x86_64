#!/bin/bash

# Function to clean and validate URL
clean_url() {
  echo "$1" | tr -d ' \r'
}

# Function to clean MD5
clean_md5() {
  echo "$1" | tr -d ' \r'
}

# Main processing loop
while IFS=, read -r NAME VERSION URL MD5SUM; do
  # Skip empty lines
  [ -z "$NAME" ] && continue

  # Clean up values
  URL=$(clean_url "$URL")
  MD5SUM=$(clean_md5 "$MD5SUM")

  # Get filename from URL
  CACHEFILE="$(basename "$URL")"

  echo "Processing: $NAME $VERSION"

  # Download if not exists
  if [ ! -f "$CACHEFILE" ]; then
    echo "Downloading $URL"
    wget --no-check-certificate "$URL" || {
      echo "Download failed for $URL"
      continue
    }
  fi

  # Verify MD5
  if ! echo "$MD5SUM $CACHEFILE" | md5sum -c --status; then
    rm -f "$CACHEFILE"
    echo "Verification failed for $CACHEFILE"
    continue
  fi

  echo "Successfully processed $NAME"
done <packages.csv
