# Entwicklungsphasen & Meilensteine

> **Quelle:** PRD v1.1, Abschnitt 9

---

## Phase 1: Prototyp (4–6 Wochen)

- Audio-Aufnahme (Vordergrund + Hintergrund) auf iPhone
- WhisperKit-Integration für On-Device-Transkription
- Einfache UI: Aufnahme → Transkript anzeigen
- Lokale Persistenz mit SwiftData
- **Ziel:** Technische Machbarkeit validieren, insbesondere WhisperKit-Performance und Hintergrundaufnahme

## Phase 2: MVP / Alpha (6–8 Wochen)

- Foundation-Model-Integration für Zusammenfassung, Action-Items, Kapitelübersicht, Tags
- `LLMService`-Protokoll implementieren und Foundation-Models-Backend einbinden
- LLM.swift-Fallback-Backend integrieren inkl. On-Demand-Modell-Download und Fortschrittsanzeige
- Vollständige Detail-View mit Tab-Wechsel
- Bearbeitungsfunktionen für Zusammenfassungen, Action-Items, Tags
- Bibliotheks-Ansicht mit Suchfunktion
- Audiodatei-Löschung nach Rückfrage
- iPad-Layout (Sidebar)
- **Ziel:** Feature-Complete für Alpha-Tester, beide LLM-Pfade validiert

## Phase 3: Beta (4–6 Wochen)

- CloudKit-Synchronisierung
- macOS-App (Catalyst oder native SwiftUI)
- Apple-Watch-App (Aufnahme + WatchConnectivity)
- Export-Funktion (Markdown, PDF)
- Lokalisierung (Deutsch + Englisch)
- **Ziel:** Plattformübergreifend nutzbar, TestFlight-Beta

## Phase 4: App Store Launch (2–4 Wochen)

- Performance-Optimierung und Bugfixing
- App-Store-Listing (Screenshots, Beschreibung, Keywords, Datenschutzerklärung)
- Preis: 0,99 € (erste 100 Nutzer)
- Review-Prozess und Launch
- **Ziel:** Erster öffentlicher Release

## Phase 5: Post-Launch / v2.0 (fortlaufend)

- Preisanpassungen basierend auf Nutzerzahlen (bis max. 4,99 €)
- Iteration basierend auf User-Feedback
- Potenzielle Erweiterungen (siehe 10_ERWEITERUNGEN.md)
