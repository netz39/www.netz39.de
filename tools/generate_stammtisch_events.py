import os
import datetime


# Function to generate the markdown content for a specific date
def generate_markdown_file(year, month, day):
    markdown_content = f"""---
layout: event
title:  "Netz39-Stammtisch"
event_date:   {year}-{month:02d}-{day:02d}
---

**Wann: 19:30 Uhr**\\
**Wo: Netz39 e.V.**

Es ist wieder Vereins-Stammtisch! Wie immer in allen ganzzahlig durch drei teilbaren Kalenderwochen. Das Protokoll dieses Stammtisches findet ihr [hier](https://wiki.netz39.de/stammtisch:{year}:{year}-{month:02d}-{day:02d}).
"""

    folder_path = "_events"
    filename = f"{year}-{month:02d}-{day:02d}_n39_stammtisch.md"
    file_path = os.path.join(folder_path, filename)

    with open(file_path, 'w') as file:
        file.write(markdown_content)

    print(f"Markdown file '{filename}' generated successfully in the _events folder!")


# Input year
input_year = int(input("Enter the year: "))

# Calculate Wednesdays in weeks divisible by three
for month in range(1, 13):
    for day in range(1, 32):
        try:
            # Generate a date object
            current_date = datetime.date(input_year, month, day)

            # Check if the date is a Wednesday and in a week divisible by three
            if current_date.weekday() == 2 and current_date.isocalendar()[1] % 3 == 0:
                generate_markdown_file(input_year, month, day)

        except ValueError:
            # If the day is out of range for the month, skip to the next month
            pass
