# AWS Face Recognition
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/JoelF09/AWS_FaceRecognition)
![AWS](img.shields.io)
![Python](img.shields.io)
![License](img.shields.io)
 
Dieses Repository enthält eine serverlose Anwendung zur Gesichsterkennung in Bildern unter Verwendung von Amazon Web Services (AWS). Das Projekt nutzt **AWS** **Lambda** und **Amazon Rekognition**, um Bilder, dir in einen S3-Bucket hochgeladen werden, automatisch zu analysieren.
 
 > [!NOTE]  
 > Dieses Projekt wurde im Rahmen des Moduls **M346** entwickelt.
 
## 📁 Architektur
 
Die Anwendung folgt einer einfachen, ereignisgesteuerten (Event-driven) serverlosen Architektur:
 
1.  **Bild Upload**: Der Benutzer lädt eine Bilddatei (z.B. `.jpg`, `.png`) in einen bestimmten S3-Bucket hoch.
2.  **Lambda Trigger**: Das S3 Ereignis `ObjectCreated` löst eine AWS Lambda-Funktion aus.
3.  **Gesichts Analyse**: Die Lambda-Funktion ruft den Amaton Rekognition-Dienst auf und übergibt das hochgeladene Bild als Eingabe
4.  **Ergebnisprotokollierung**: Rekognition analysiert das Bild auf Gesichert und gibt Metadaten zurück (z.B. Begrenzungsrahmen, Konfidenzwerte und Gesichtsmerkmale). Die Lambda-Funktion verarbeitet diese Ergebnisse und protokolliert sie zur Überprüfung in Amazon CloudWatch.
 
## 💫 Funktionen
 
-   **Automatische Gesichtserkennung**: Erkennt und analysiert Gesichter in Bildern automatisch beim Hochladen.
-   **Serverlos**: Basiert vollständig auf verwalteten AWS-Diensten, sodass keine Serverbereitstellung oder -verwaltung erforderlich ist.
-   **Skalierbar**: Die Architektur skaliert automatisch mit der Anzahl der hochgeladenen Bilder.
-   **Kostengünstig**: Pay-per-Use-Model für S3, Lambda und Rekognition.
 
## 🚀 Erste Schritte
 
### Voraussetzungen
 
-   AWS CLI installiert und mit `aws configure` [konfiguriert](https://docs.aws.amazon.com).
-   Eine Unix-ähnliche ShellUmgebung (z.B Linux, maxOS oder WSL unter Windows) zum Ausführen von Shell-Skripten.
 
### Installation
 
1.  **Das Repository klonen:**
    ```sh
    git clone https://github.com/JoelF09/AWS_FaceRecognition.git
    cd AWS_FaceRecognition
    ```
2.  **lambda.zip erzeugen:**
    ```sh
    cd lambda
    zip ../lambda.zip lambda_function.py
    cd ..
    ```
3.  **Führe das Initialisierungsskript aus:**
    Dieses Skript richtet alle erforderlichen AWS-Ressourcen ein, darunter den S3-Bucket, die IAM-Rollen und die Lambda-Funktion.
 
    ```sh
    chmod +x scripts/init.sh
    ./scripts/init.sh
    ```
    Folge den Anweisungen im Terminal    
 
## 🧪 Testing
 
Ein Testskript vereinfacht das Testen der Einrichtung. Das Skript lädt ein Beispielbild aus dem Verzeichnis `testdata/` in deinen S3-Bucket hoch.
 
1.  **Stelle sicher, dass du ein Testbild hast** In dem `testdata/` Verzeichnis.
 
2.  **Das test Skript ausführen:**
    ```sh
    chmod +x scripts/test.sh
    ./scripts/test.sh
    ```
 
3.  Das Skript fordert dich zur Eingabe aller erforderlichen Parameter auf, beispielsweise den Namen des S3-Buckets.
 
4. **Ergebnisse prüfen:**
 
    - Schaue in die AWS Management Console unter **Cloud Watch Logs** der Lambda-Funktion, um dir erkannten Gesichtsdaten zu sehen. Die Gesichtsdaten werden auch im Terminal ausgegeben und zugleich wird auch ein out.json file erstellt mir den Daten.
 
## 📂 Projektstruktur
 
```
.
├── docs/
|   ├── 01_projektuebersicht_undziele.md                # Dokumentation 01
|   ├── 02_architektur_und_technische_umsetzung.md      # Dokumentation 02
|   └── 03_projektorganisation_tests_und_reflexion.md   # Dokumentation 03
├── lambda/
│   └── lambda_function.py  # Python Code für die Lambda Funktion.
├── scripts/
│   ├── init.sh             # Skript zum Bereitstellen von AWS-Ressourcen.
│   └── test.sh             # Skript zum Testen der Anwendung durch Hochladen eines Bilders.
├── testdata/               # Verzeichnis für Testbilder.
|   ├── angelina.png        # Bild für Testzwecke
|   └── brad.png            # Bild für Testzwecke
├── lambda.zip              # Deployment-Packet (wird generiert)
├── LICENSE                 # MIT Lizenz
├── out.json                # Gesichtsdaten (wird generiert)
└── README.md               # Dieses README.md File
```
 
## Lizenz
 
Dieses Projekt unterliegt der MIT-Lizenz. Weitere Informationen findest du in der Datei [LICENSE](LICENSE).