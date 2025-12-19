# Architektur und technische Umsetzung

## Gesamtarchitektur

Der AWS FaceRecognition Service basiert auf einer serverlosen und ereignisgesteuerten Architektur. Es werden keine permanent laufenden Server benötigt. Die Verarbeitung erfolgt ausschliesslich bei Bedarf.

Der grundlegende Ablauf ist wie folgt:

1. Upload eines Bildes in den S3 Eingabe Bucket
2. Auslösung eines S3 ObjectCreated Events
3. Automatischer Aufruf der AWS Lambda Funktion
4. Analyse des Bildes mit AWS Rekognition
5. Speicherung der Analyseergebnisse als JSON Datei im Ausgabe Bucket

## S3 Buckets

### Eingabe Bucket

Der Eingabe Bucket dient zur Aufnahme von Bilddateien. Unterstützt werden gängige Bildformate wie JPG, JPEG und PNG. Jeder Upload in diesen Bucket löst automatisch die Lambda Funktion aus.

### Ausgabe Bucket

Der Ausgabe Bucket enthält die Ergebnisse der Gesichtserkennung. Zu jedem hochgeladenen Bild wird eine JSON Datei mit dem gleichen Namen und der Endung json gespeichert.

## Lambda Funktion

Die Lambda Funktion ist in Python implementiert. Sie übernimmt folgende Aufgaben:

- Entgegennahme des S3 Events
- Prüfung des Dateityps
- Übergabe des Bildes an AWS Rekognition
- Verarbeitung der Analyseantwort
- Speicherung des Ergebnisses im Ausgabe Bucket

Die Lambda Funktion wird ausschliesslich ereignisgesteuert ausgeführt und benötigt keine manuelle Auslösung.

## AWS Rekognition

AWS Rekognition wird für die Erkennung bekannter Persönlichkeiten verwendet. Der Dienst liefert unter anderem folgende Informationen:

- Name der erkannten Person
- Trefferwahrscheinlichkeit
- Geschätztes Geschlecht
- Bounding Box des Gesichts
- Zusätzliche Referenz URLs

Diese Informationen werden unverändert als JSON Datei gespeichert.

## Berechtigungen

Die Lambda Funktion verfügt über die notwendigen IAM Berechtigungen, um:

- Objekte aus dem Eingabe Bucket zu lesen
- Objekte in den Ausgabe Bucket zu schreiben
- Den Rekognition Service zu verwenden

Der Eingabe Bucket besitzt eine explizite Berechtigung zur Auslösung der Lambda Funktion.

## Automatisierung

Die komplette Infrastruktur wird über ein Init Script erstellt. Dieses Script erzeugt und konfiguriert:

- S3 Eingabe und Ausgabe Buckets
- AWS Lambda Funktion inklusive Environment Variablen
- Lambda Invoke Berechtigungen
- S3 Event Benachrichtigungen

Das Init Script ist mehrfach ausführbar und erkennt bereits existierende Ressourcen, wodurch eine wiederholbare und stabile Inbetriebnahme möglich ist.
