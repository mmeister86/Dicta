# Technische Herausforderungen & Mitigationsstrategien

> **Quelle:** PRD v1.1, Abschnitt 10

---

## 1. WhisperKit-Performance bei langen Aufnahmen

- **Risiko:** Stundenlange Aufnahmen könnten den Arbeitsspeicher sprengen oder zu inakzeptablen Verarbeitungszeiten führen.
- **Mitigation:** Audio in Chunks aufteilen (z.B. 5-Minuten-Segmente) und sequenziell transkribieren. Fortschrittsanzeige implementieren. Verschiedene WhisperKit-Modellgrößen anbieten (kleiner = schneller, aber weniger genau).

## 2. Foundation-Model-Kontextlänge

- **Risiko:** Sehr lange Transkripte könnten die Kontextlänge der On-Device Foundation Models überschreiten.
- **Mitigation:** Text in sinnvolle Abschnitte segmentieren, pro Abschnitt aufbereiten, und Teilergebnisse zusammenführen. Die Kapitelübersicht kann als natürliche Segmentierungsgrundlage dienen.

## 3. Hintergrundaufnahme und System-Einschränkungen

- **Risiko:** iOS kann Background-Audio-Sessions unter Speicherdruck beenden.
- **Mitigation:** Regelmäßiges Zwischenspeichern der Audiodaten. Graceful Recovery, falls die Session unterbrochen wird (Teilaufnahme behalten, User informieren).

## 4. CloudKit-Limits und große Datenmengen

- **Risiko:** Bei intensiver Nutzung könnten CloudKit-Quotas (insbesondere in der kostenlosen Tier) erreicht werden.
- **Mitigation:** Audiodateien nicht synchronisieren (nur Textdaten). Effiziente Delta-Sync-Strategie. Monitoring der Quota-Nutzung.

## 5. Watch-zu-iPhone Audio-Transfer

- **Risiko:** WatchConnectivity kann bei großen Dateien langsam sein oder fehlschlagen.
- **Mitigation:** Audio auf der Watch komprimiert speichern und im Hintergrund übertragen (`transferFile`). Robustes Error-Handling und Retry-Mechanismus. User über Transfer-Status informieren.

## 6. Sprachgenauigkeit bei Fachvokabular

- **Risiko:** WhisperKit könnte bei domänenspezifischem Vokabular (medizinisch, juristisch, technisch) ungenau transkribieren.
- **Mitigation:** Das Rohtranskript als editierbare Grundlage anbieten. Langfristig ggf. benutzerdefinierte Wörterbücher evaluieren.

## 7. Qualitätsunterschied zwischen LLM-Backends

- **Risiko:** Das Fallback-Modell ist deutlich kleiner als das Foundation-Model-Backend. Die Qualität von Zusammenfassungen und Action-Items könnte merklich schlechter sein, was zu unterschiedlichen Nutzererfahrungen je nach Gerät führt.
- **Mitigation:** Prompts für das Fallback-Modell separat optimieren und auf kompaktere, präzisere Ausgaben trimmen. Im Alpha-Test gezielt auf Geräten ohne Apple Intelligence validieren. Bei unzureichender Qualität ggf. auf ein größeres Fallback-Modell (3B–4B, Q4) wechseln – zu Lasten des Download-Volumens (~1,5–2 GB).

## 8. Fallback-Modell-Download: Nutzerakzeptanz und Netzwerkabbrüche

- **Risiko:** Ein einmaliger ~500-MB-Download könnte Nutzer abschrecken oder bei schlechter Verbindung fehlschlagen.
- **Mitigation:** Download nur auf explizite Nutzerbestätigung hin starten. Fortschrittsanzeige mit verständlicher Erklärung einblenden. Resumable Downloads implementieren (URLSession Background Transfer). Die App bleibt bis zum Download voll nutzbar – nur die Aufbereitung steht aus.
