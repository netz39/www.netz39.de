#!/bin/bash

git checkout main > /dev/null
git pull origin main || exit 1

# If no argument is supplied ask for the date of the next Stammtisch
if [ $# -eq 0 ]; then
    echo "When is the next Stammtisch? (YYYY-MM-DD)"
    read date
else
    date=$1
    echo "Using date $date"
fi

# Parse the date
year=$(echo $date | cut -d'-' -f1)
month=$(echo $date | cut -d'-' -f2)
day=$(echo $date | cut -d'-' -f3)
dow=$(date -d $date +%A)
Month=$(date -d $date +%B)

root_dir=`git rev-parse --show-toplevel`
filename="$year-$month-${day}_softwerke_stammtisch.md"

# Create a new branch. delete it if it already exists
git branch -D "events/$filename" > /dev/null 2>&1
git checkout -b "events/$filename" > /dev/null || exit 1

# Create the new file
mkdir "$root_dir/_events/$year"
cat > "$root_dir/_events/$year/$filename" <<EOF
---
layout: event
title: "Softwerke-Stammtisch"
tags: [recurring,external]
event:
  start: ${date} 19:30:00
  end: ${date} 21:30:00
author: softwerke
---

Am ${dow} den ${day#"${day%%[!0]*}"}. ${Month} ${year} findet der Stammtisch der Softwerke Magdeburg e. V. bei uns im Space statt!
EOF

# Add the file to git
git add "$root_dir/_events/$year/$filename" || exit 1

# Commit the file
git commit -m "Add event for $date" || exit 1