# Projektorganisation, Tests und Reflexion

## Projektorganisation

Die Projektarbeit wurde in einer Dreiergruppe durchgeführt. Die Zusammenarbeit erfolgte strukturiert und zielorientiert. Alle Projektdateien wurden in einem gemeinsamen Git Repository versioniert, sodass Änderungen und Beiträge der einzelnen Teammitglieder nachvollziehbar sind.


## Aufgabenteilung im Projektteam

Béla Lüchinger  
Verantwortlich für die Projektdokumentation. Dazu gehörten die Strukturierung der Markdown Dateien, die Beschreibung des Cloud Services sowie die Reflexion der Scripte. 

Joel Felix  
Verantwortlich für die Projektstruktur und das Init Script. Er übernahm die automatisierte Erstellung und Konfiguration der AWS Ressourcen und die übersicht über das Repository sowie die Aufbereitung der Testergebnisse und das Testing der Scripte.

Joelle Sezer  
Verantwortlich für den Lambda Function Code sowie das Test Script. Sie implementierte die Gesichtserkennung mit AWS Rekognition und das automatisierte Testverfahren.

## Testkonzept

Zur Überprüfung der Funktionalität wurde ein automatisiertes Test Script eingesetzt. Dieses testet den Service End to End und umfasst folgende Schritte:

- Upload eines Testbildes in den Eingabe Bucket
- Automatisches Warten auf die Verarbeitung durch die Lambda Funktion
- Download der erzeugten JSON Ergebnisdatei aus dem Ausgabe Bucket
- Strukturierte Ausgabe der erkannten Persönlichkeiten

## Testergebnisse

Die Tests bestätigten die korrekte Funktion des Services. Bekannte Persönlichkeiten wurden erfolgreich erkannt und mit einer entsprechenden Trefferwahrscheinlichkeit ausgegeben. Die erzeugten JSON Dateien entsprachen der erwarteten Struktur.

## Erkenntnisse aus den Tests

- Die ereignisgesteuerte Architektur funktioniert stabil
- Die Automatisierung reduziert manuelle Fehlerquellen
- Die Trennung von Eingabe und Ausgabe Bucket erhöht die Übersichtlichkeit
- AWS Rekognition liefert detaillierte und gut strukturierte Analyseergebnisse

## Reflexion und Ausblick

Das Projekt bot einen praxisnahen Einblick in die Umsetzung einer serverlosen Cloud Architektur. Besonders wertvoll war die Kombination aus Automatisierung, Cloud Services und strukturierter Dokumentation.

Für ein weiterführendes Projekt wären Erweiterungen wie zusätzliche Analysefunktionen oder eine grafische Benutzeroberfläche denkbar. Insgesamt entspricht das Projektergebnis den Anforderungen des Projektauftrags und der Arbeit einer Fachperson.

Der einzige Rückschlag während des Projekts war, dass eines der Dokumentationsfiles neu geschrieben werden musste. Zu Beginn war uns nicht bewusst, dass Umlaute problemlos in einer Markdown Readme Datei verwendet werden können. Dieser Fehler führte zu einem zusätzlichen Arbeitsaufwand, konnte jedoch ohne grössere Auswirkungen auf den Projektfortschritt behoben werden.

Ebenfalls traten kleinere Probleme bei den Scripts auf, insbesondere während der ersten Testläufe. Diese Fehler konnten jedoch schnell identifiziert und zeitnah behoben werden, da die Struktur der Scripts klar aufgebaut war und systematisch getestet wurde.
