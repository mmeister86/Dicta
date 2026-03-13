# Nicht-funktionale Anforderungen (NFRs)

> **Quelle:** PRD v1.1, Abschnitt 8

---

| Anforderung | Zielwert | Anmerkung |
|------------|---------|-----------|
| Transkriptionsgeschwindigkeit | < 1 Minute Verarbeitung pro 10 Minuten Audio | Abhängig vom Gerätemodell und WhisperKit-Konfiguration |
| Aufbereitungsgeschwindigkeit | < 30 Sekunden nach Transkription | Abhängig von Textlänge und Foundation-Model-Performance |
| Maximale Aufnahmedauer | Begrenzt durch verfügbaren Gerätespeicher | Klare Anzeige des verfügbaren Speichers / geschätzter Restdauer |
| App-Startzeit | < 2 Sekunden (Cold Start) | Lazy Loading für Modell-Initialisierung |
| Akku-Verbrauch (Aufnahme) | Vergleichbar mit Apples Sprachmemos-App | Background Audio Mode optimiert nutzen |
| Offline-Fähigkeit | Vollständig offline nutzbar (Kern-Features) | CloudKit-Sync, wenn Netzwerk verfügbar |
| Speicherverbrauch (App) | < 500 MB inkl. WhisperKit-Modell | WhisperKit bietet verschiedene Modellgrößen; Fallback-LLM-Modell (Qwen3.5-0.8B Q4_K_M, ~500 MB) wird separat on-demand gecacht |
| Sync-Latenz | < 30 Sekunden nach Änderung bei verfügbarem Netzwerk | CloudKit Push Notifications |
