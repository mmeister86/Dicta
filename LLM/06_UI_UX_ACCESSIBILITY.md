# UI/UX-Prinzipien & Accessibility

> **Quelle:** PRD v1.1, Abschnitt 6

---

## Design-Prinzipien

- **Apple Human Interface Guidelines:** Die App folgt konsequent Apples Designsprache – native Controls, System-Farben, plattformspezifische Navigation (TabBar auf iPhone, Sidebar auf iPad/Mac).
- **Minimalismus:** Der Aufnahme-Button steht im Zentrum. Ein Tap startet die Aufnahme, kein Onboarding-Overhead.
- **Progressive Disclosure:** Nach der Aufnahme erscheinen die Ergebnisse schrittweise – zuerst das Transkript (schneller), dann Zusammenfassung und Action-Items (LLM-Verarbeitung).
- **Plattformoptimierung:** Jede Plattform erhält ein angepasstes Layout (z.B. Sidebar-Navigation auf iPad/Mac, kompakte Glances auf der Watch).

## Accessibility (a11y)

- Vollständige **VoiceOver-Unterstützung** auf allen Plattformen
- **Dynamic Type** für anpassbare Schriftgrößen
- Ausreichende **Farbkontraste** nach WCAG 2.1 AA
- Unterstützung von **Bold Text** und **Reduce Motion** Systemeinstellungen
- Alle interaktiven Elemente mit aussagekräftigen **Accessibility Labels**

## Watch-UI

- Fokus auf die zwei Kernaktionen: Aufnahme starten/stoppen und letzte Ergebnisse einsehen
- Kompakte Darstellung: Titel, Tags, Zusammenfassung (gekürzt)
- Keine vollständige Bearbeitungsfunktion auf der Watch
