#!/usr/bin/env python3

import os
import datetime
import locale


locale.setlocale(locale.LC_TIME, "de_DE.UTF-8")

# Function to generate the markdown content for a specific date
def generate_markdown_file(date: datetime.date):
    markdown_content = f"""---
layout: event
title: "Softwerke-Stammtisch"
tags: [recurring,external]
event:
  start: {date:%Y-%m-%d} 19:30:00
  end: {date:%Y-%m-%d} 21:30:00
author: softwerke
---

Am {date:%A} dem {date:%-d. %B %Y} findet der Stammtisch der Softwerke Magdeburg e. V. bei uns im Space statt!
"""
    dirname = os.path.dirname(__file__)
    folder_path = os.path.join(dirname, f"../_events/{date:%Y}/")
    filename = f"{date:%Y-%m-%d}_softwerke_stammtisch.md"
    file_path = os.path.join(folder_path, filename)

    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

    with open(file_path, "w") as file:
        file.write(markdown_content)

    print(f"Markdown file '{filename}' generated successfully in the _events folder!")


# Input year
input_year = int(input("Enter the year: "))

# Find second friday of each month
for month in range(1, 13):
    for day in range(8, 32):
        # Generate a date object
        current_date = datetime.date(input_year, month, day)

        # Check if the date is a friday
        if current_date.weekday() == 4:
            generate_markdown_file(current_date)
            break