import os
import datetime


# Function to generate the markdown content for a specific date
def generate_markdown_file(year, month, day):
    markdown_content = f"""---
layout: event
title:  "Freies Hacken"
event_date:   {year}-{month:02d}-{day:02d}
---
**Wann: 19:30 Uhr**\\
**Wo: Netz39 e.V.**
Jeden Mittwoch treffen wir uns zum Basteln, Reparieren, Kochen und Ideen austauschen. Gäste sind gerne willkommen

Bitte beachtet, dass jede dritte Woche unser Stammtisch ist, wo wir über vereinsinterne Sachen reden und erst anschließend zum gemütlichen Abend übergehen.
"""

    folder_path = "_events"
    filename = f"{year}-{month:02d}-{day:02d}_n39_freies_hacken.md"
    file_path = os.path.join(folder_path, filename)

    with open(file_path, 'w', encoding='utf-8') as file:
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

            # Check if the date is a Wednesday
            if current_date.weekday() == 2:
                generate_markdown_file(input_year, month, day)

        except ValueError:
            # If the day is out of range for the month, skip to the next month
            pass
