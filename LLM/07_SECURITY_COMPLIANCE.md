# Security & Compliance

> **Quelle:** PRD v1.1, Abschnitt 7

---

## Datenschutz / DSGVO

- **Privacy by Design:** Keine Daten verlassen das Gerät zur KI-Verarbeitung. Dies ist das zentrale Alleinstellungsmerkmal und muss in der App-Store-Beschreibung und im Marketing prominent kommuniziert werden.
- **Kein eigener Account:** Authentifizierung erfolgt ausschließlich über den Apple-Account – keine zusätzlichen personenbezogenen Daten werden erhoben.
- **CloudKit:** Daten werden verschlüsselt in Apples Private Database gespeichert. Nur der User hat Zugriff. Apple selbst kann die Daten in der Private Database nicht lesen (Ende-zu-Ende-Verschlüsselung bei aktiviertem Advanced Data Protection).
- **Kein Tracking:** Keine Analytics-SDKs von Drittanbietern. Falls gewünscht, ausschließlich Apples eigenes App Analytics im App Store Connect.
- **Datenschutzerklärung:** Notwendig für den App Store. Muss klar kommunizieren, welche Daten erhoben (keine) und wie sie verarbeitet werden (lokal).

## App-Transport-Security

- Im Normalbetrieb keine externen Netzwerkverbindungen nötig (außer CloudKit, das ATS-konform ist).
- **Ausnahme Fallback-Modell-Download:** Beim einmaligen On-Demand-Download des LLM.swift-Fallback-Modells wird eine HTTPS-Verbindung zu Hugging Face benötigt. Diese ist ATS-konform. Nach dem Download ist die App wieder vollständig offline-fähig.

## Mikrofon-Berechtigung

- Klare, verständliche Beschreibung im Permission-Dialog, warum die App Zugriff auf das Mikrofon benötigt.
