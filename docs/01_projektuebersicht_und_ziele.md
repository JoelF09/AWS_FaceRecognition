# Projektübersicht und Zielsetzung

## Projektübersicht

Dieses Projekt wurde im Rahmen des Moduls 346 Cloudlösungen konzipieren und realisieren umgesetzt. Ziel der Projektarbeit war die Konzeption, Implementierung und Dokumentation eines Cloud Services zur automatischen Erkennung bekannter Persönlichkeiten auf Fotos unter Verwendung von AWS Cloud Services.

Der entwickelte Service arbeitet ereignisgesteuert. Wird ein Bild in einen definierten S3 Eingabe Bucket hochgeladen, wird automatisch eine AWS Lambda Funktion ausgelöst. Diese analysiert das Bild mit dem AWS Dienst Rekognition und speichert das Ergebnis der Analyse als JSON Datei in einem separaten S3 Ausgabe Bucket.

Die komplette Bereitstellung sowie der Test des Services erfolgen vollautomatisiert über CLI Skripte. Alle benötigten Dateien sowie die Dokumentation sind versioniert in einem Git Repository abgelegt.

## Zielsetzung gemäss Projektauftrag

Mit der Projektarbeit sollen folgende Ziele erreicht werden:

- Umsetzung eines Cloud Services zur Erkennung bekannter Persönlichkeiten auf Fotos
- Verwendung von AWS S3, AWS Lambda und AWS Rekognition
- Automatisierte Inbetriebnahme des Services im AWS Learner Lab
- Vollständige Versionierung aller Projektdateien in einem Git Repository
- Strukturierte und nachvollziehbare Dokumentation in Markdown
- Test und Protokollierung der Funktionalität

## Beschreibung des Services

Der FaceRecognition Service besteht aus zwei S3 Buckets und einer Lambda Funktion. Der Eingabe Bucket dient zur Aufnahme von Bilddateien. Jede neu hochgeladene Datei löst automatisch die Lambda Funktion aus. Diese übergibt das Bild an AWS Rekognition, wertet das Analyseergebnis aus und speichert dieses als JSON Datei im Ausgabe Bucket.

Die Verarbeitung erfolgt vollautomatisch und ohne manuelle Eingriffe.

## Hauptkomponenten

Der Service setzt sich aus folgenden Komponenten zusammen:

- S3 Eingabe Bucket für Bilddateien
- AWS Lambda Funktion zur Bildanalyse
- AWS Rekognition zur Gesichtserkennung
- S3 Ausgabe Bucket zur Speicherung der Analyseergebnisse
- Init Script zur automatisierten Inbetriebnahme
- Test Script zur automatisierten Funktionsprüfung

## Eingesetzte Technologien

- Amazon Web Services
- AWS S3
- AWS Lambda
- AWS Rekognition
- AWS CLI
- Bash
- Python
- Git
- Markdown
