# Projektübersicht – Intelligenter Sprachrekorder

> **PRD-Version:** 1.1 | **Datum:** 11. März 2026 | **Status:** Entwurf

---

## Vision

Eine Apple-native App, die gesprochene Gedanken in strukturierte, verwertbare Informationen verwandelt – vollständig auf dem Gerät, ohne Cloud-KI-Dienste, mit maximaler Privatsphäre.

## Problemstellung

Menschen generieren täglich wertvolle Inhalte durch Sprechen – in Meetings, Vorlesungen, beim Brainstorming oder unterwegs. Dieses Wissen geht verloren, weil:

- Manuelle Notizen unvollständig und zeitaufwändig sind
- Bestehende Transkriptions-Apps Audiodaten in die Cloud senden und damit Datenschutzbedenken aufwerfen
- Rohe Transkripte ohne Aufbereitung schwer konsumierbar sind
- Es keine nahtlose Apple-Ökosystem-Lösung gibt, die Aufnahme, Transkription und intelligente Aufbereitung vereint

## Lösungsansatz

Die App nimmt Audio auf (auch im Hintergrund bei gesperrtem Gerät), transkribiert nach Aufnahmeende on-device mit WhisperKit und generiert automatisch via Apples Foundation Models eine Zusammenfassung, Action-Items, eine Kapitelübersicht sowie automatische Tags – alles ohne dass Daten das Gerät verlassen.

Auf Geräten ohne Apple Intelligence (d.h. ohne A17 Pro / M1-Chip oder mit deaktivierter Apple-Intelligence-Funktion) greift die App auf ein eingebettetes Open-Source-LLM zurück, das on-demand heruntergeladen und lokal ausgeführt wird. Die intelligente Aufbereitung bleibt damit auf der gesamten unterstützten Gerätebasis vollständig privat und funktionsfähig.

## Zielgruppe & User Personas

Die App richtet sich bewusst an ein breites Publikum:

### Persona 1: Studierende/r
- **Kontext:** Mitschnitt von Vorlesungen und Seminaren
- **Bedürfnis:** Strukturierte Zusammenfassungen und automatisch extrahierte Schlüsselthemen
- **Pain Point:** Kann nicht gleichzeitig zuhören und vollständig mitschreiben

### Persona 2: Wissensarbeiter/in
- **Kontext:** Meeting-Notizen, Kundengespräche, Brainstorming-Sessions
- **Bedürfnis:** Klare Action-Items und Zusammenfassungen, die direkt weiterverwendbar sind
- **Pain Point:** Meeting-Ergebnisse gehen verloren oder müssen mühsam nachbereitet werden

### Persona 3: Kreative/r & Autor/in
- **Kontext:** Ideenfindung, Diktieren von Texten, Gedankensammlung
- **Bedürfnis:** Unstrukturierte Gedanken in geordneter Form festhalten
- **Pain Point:** Kreative Einfälle kommen oft in Momenten, in denen Tippen unpraktisch ist

### Persona 4: Selbstständige/r & Gründer/in
- **Kontext:** Projektideen, Kundenanforderungen, Selbstorganisation
- **Bedürfnis:** Schnelle Dokumentation mit direkten To-Dos
- **Pain Point:** Kein Zeitbudget für aufwändige Nachbereitung

> **Hinweis:** Die breite Aufstellung erlaubt es, im Markt zu beobachten, wo organische Traction entsteht, und die Produktstrategie entsprechend iterativ zu schärfen.

## Geschäftsmodell

| Aspekt | Details |
|--------|--------|
| Modell | Einmalkauf (kein Abo) |
| Startpreis | 0,99 € |
| Preisstaffelung | 0,99 € (erste 100 User) → 1,99 € (bis 1.000 User) → stufenweise bis max. 4,99 € |
| Laufende Kosten | Keine (kein Backend, On-Device-Verarbeitung) |
| Distribution | Apple App Store (Universal Purchase für iPhone, iPad, Mac, Watch) |
| Alpha/Beta | Kostenlos via TestFlight |
