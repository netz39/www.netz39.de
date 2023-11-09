import os
import datetime

layout = "event"
title = "Freies Hacken"
event_description = f"""
**Wann: 19:30 Uhr**\\
**Wo: Netz39 e.V.**

Jeden Mittwoch treffen wir uns zum Basteln, Reparieren, Kochen und Ideen austauschen. Gäste sind gerne willkommen

Bitte beachtet, dass jede dritte Woche unser Stammtisch ist, wo wir über vereinsinterne Sachen reden und erst anschließend zum gemütlichen Abend übergehen.
"""
folder_name = "_events"
filename_prefix = "n39_freies_hacken"

# Function to generate the markdown content for a specific date
def generate_markdown_file(year, month, day):
    markdown_content = f"""---
layout: {layout}
title: {title}
event_date: {year}-{month:02d}-{day:02d}
---
{event_description}
"""

    folder_path = f"../{folder_name}/{year}/"
    filename = f"{year}-{month:02d}-{day:02d}_{filename_prefix}.md"
    file_path = os.path.join(folder_path, filename)

    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(markdown_content)

    print(f"Markdown file '{filename}' generated successfully in the '{folder_path}' folder!")


# Input year
input_year = int(input("Enter the year: "))

# Calculate Wednesdays
for month in range(1, 13):
    for day in range(1, 32):
        try:
            # Generate a date object
            current_date = datetime.date(input_year, month, day)

            # Check if the date is a Wednesday
            if current_date.weekday() == 2:
                generate_markdown_file(input_year, month, day)

        except ValueError:
            # If the day is out of range for the month, skip to the next month
            pass
