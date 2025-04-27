# [www.netz39.de](https://www.netz39.de)

## Warum Jekyll?

Unsere Webseite setzt aus folgenden Gründen auf Jekyll, einen statischen Website-Generator:

- **Einfache Handhabung:** Jekyll ermöglicht es, Inhalte in Markdown zu schreiben, was die Erstellung und Aktualisierung von Webseiten vereinfacht.

- **Schnelle Ladezeiten:** Da Jekyll statische Seiten generiert, werden die Webseiten schnell geladen.

- **GitHub Pages Integration:** Jekyll wird von GitHub Pages unterstützt, was bedeutet, dass wir unsere Website direkt aus dem GitHub-Repository hosten können.

## Neue Blogeinträge erstellen:

1. **Blogeintrag erstellen:**

    - Erstelle eine neue Markdown-Datei im `_posts`-Verzeichnis unter das aktuelle Jahr. Benenne die Datei nach dem Format `YYYY-MM-DD-titel-des-eintrags.md`
    - **Front Matter:** Füge am Anfang der Datei das YAML-Front Matter hinzu. Das Front Matter enthält Metadaten für den Blogeintrag, wie z.B. den Layout-Typ, den Titel, den Autor und das Veröffentlichungsdatum. Hier ein Beispiel für das Front Matter:

        ```yaml
        ---
        layout: post
        title: "Titel des Blogeintrags"
        author: MaxMustermann
        date: 2023-10-20
        feature-img: "https://cdn.netz39.de/img/feature-img.jpg" # optional
        thumbnail: "https://cdn.netz39.de/img/thumbnail-img.jpg" # optional
        ---
        ```
    - Schreibe den Inhalt deines Blogeintrags im Markdown-Format unterhalb des Front Matter.
    - Bilder eines Blogeintrags werden unter `https://cdn.netz39.de/img/post-img`in das jeweilige Jahr abgelegt.

2. **Pull Request erstellen:**

    - Erstelle einen neuen Branch, füge die Markdown-Datei hinzu und committe/pushe sie.
    - Erstelle einen Pull Request von deinem Branch zum Hauptbranch im GitHub-Repository.
    - Teammitglieder können deine Änderungen überprüfen und den Pull Request akzeptieren.

## Neue Events erstellen:

- Analog zu "Blogeintrag erstellen" wird im `_events`-Verzeichnis eine Markdown-Datei erstellt.
- Das Front Matter sollte wie folgt aussehen:
    ```yaml
    ---
    layout: event
    title: "Titel des Events"
    author: MaxMustermann # optional, soll angegeben werden, wenn du der Ansprechpartner des Events bist
    event:
      start: 2023-10-20 19:00:00 # Datum, an dem das Event stattfindet. Die Zeit ist optional
      end:   2023-10-20 21:00:00 # optional, Zeitpunkt, an dem das Event endet
      organizer: "Netz39 Team <kontakt@netz39.de>" # optional, Kontaktdaten im ical Event
      location: "Netz39 e.V." # optional, Ort des Events
      tags: '[example,halloWelt]' # every tag will result in a seperate ics feed
      rrule: "FREQ=MONTHLY;INTERVAL=1;BYDAY=1FR,1TH" # follows https://icalendar.org/iCalendar-RFC-5545/3-3-10-recurrence-rule.html  
    ---
    ```
- Unterhalb des Front Matters die Beschreibung des Events in Markdown aufschreiben
- Bei der Angabe der Zeiten müssen folgende Regeln eingehalten werden:
    - `event.end` darf nicht vor `event.start` liegen
    - Wenn `event.end` angegeben ist, dann muss `event.start` eine Uhrzeit enthalten
    - Wenn `event.end` weggelassen wird, dann wird das Ereignis auf der [Homepage](https://www.netz39.de/events) ganztagig und im ical Feed mit Uhrzeit angezeigt
    - Wenn keine Uhrzeit in `event.start` angegeben ist, dann wird das Event auch im ical Feed ganztagig angezeigt
    - Mehrtägige Events werden nur mit Angabe der Uhrzeiten korrekt dargestellt

## Installation und lokale Entwicklung mit Docker:

1. Docker und Docker Compose auf deinem System installieren
2. Docker Container im root-Verzeichnis starten:
   ```bash
   docker-compose up
   ```

   Der Jekyll-Buildserver wird nun in einem Docker-Container gestartet und ist unter `http://localhost:4000` verfügbar. Du kannst Änderungen vornehmen, und sie werden automatisch in Echtzeit aktualisiert.
3. Nach der Entwicklung den Container mit `docker-compose down` beenden.

## git-lfs

Dieses Repository nutzt zur Verwaltung von großen Binärdaten (Bilder und PDFs) [git-lfs](https://git-lfs.com/). Zur Installation folge bitte der [Installationsanleitung für dein Betriebssystem](https://github.com/git-lfs/git-lfs#installing).

Die Arbeit mit den Dateien ändert sich durch die Verwendung von git-lfs nicht.

## pre-commit

Dieses Reoisitory nutzt [pre-commit](https://pre-commit.com/), um git pre-commit-hooks auszuführen.

### [Installation](https://pre-commit.com/#installation)

```bash
# install package
pip install pre-commit
# install pre-commit-hooks in repo
pre-commit install
# run (new) hooks against all files in repo
pre-commit run --all-files
```

### Genutzte hooks

Siehe [.pre-commit-config.yaml](./.pre-commit-config.yaml)

## License

© Netz39 e.V

- Uses [Type-on-strap](https://github.com/sylhare/Type-on-Strap) theme licensed under [The MIT License (MIT)](/LICENSE)
- Uses Pictures from [Pexels](https://www.pexels.com/) licensed under Creative Commons Zero (CC0) license
- Uses Fonts which are licensed under the [SIL Open Font License (OFL)](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)


