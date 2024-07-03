# Tools for [www.netz39.de](https://www.netz39.de)

## Netz 39 Stammtisch Events erzeugen

```bash
cd tools
python3 generate_stammtisch_events.py
```
> Enter the year: 2024

Output:

```bash
Markdown file '2024-01-17_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-02-07_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-02-28_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-03-20_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-04-10_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-05-01_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-05-22_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-06-12_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-07-03_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-07-24_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-08-14_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-09-04_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-09-25_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-10-16_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-11-06_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-11-27_n39_stammtisch.md' generated successfully in the _events folder!
Markdown file '2024-12-18_n39_stammtisch.md' generated successfully in the _events folder!
```

## Softwerke Stammtisch Event erzeugen

```bash
cd tools
./generate_softwerke_stammtisch.sh
```
> When is the next Stammtisch? (YYYY-MM-DD)

> 2024-07-05

Output:

```bash
Zu neuem Branch 'events/2024-07-05_softwerke_stammtisch.md' gewechselt
[events/2024-07-05_softwerke_stammtisch.md 6a22bef] Add event for 2024-07-05
 1 file changed, 10 insertions(+)
 create mode 100644 _events/2024/2024-07-05_softwerke_stammtisch.md
```

Branch veröffentlichen:
```bash
git push origin events/2024-07-05_softwerke_stammtisch.md
```