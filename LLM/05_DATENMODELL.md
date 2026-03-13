# Konzeptionelles Datenmodell

> **Quelle:** PRD v1.1, Abschnitt 5

---

## Modellstruktur

```
Recording (Aufnahme)
├── id: UUID
├── title: String (auto-generiert durch LLM, editierbar)
├── createdAt: Date
├── duration: TimeInterval
├── audioFileURL: URL? (optional, nach Löschfrage)
├── processingStatus: Enum (aufgenommen, transkribiert, aufbereitet, llm_ausstehend)
│
├── transcript: Transcript
│   ├── id: UUID
│   ├── rawText: String
│   └── language: String
│
├── summary: Summary
│   ├── id: UUID
│   └── text: String (editierbar)
│
├── actionItems: [ActionItem]
│   ├── id: UUID
│   ├── text: String (editierbar)
│   ├── isCompleted: Bool
│   └── sortOrder: Int
│
├── chapters: [Chapter]
│   ├── id: UUID
│   ├── title: String
│   ├── summary: String
│   └── sortOrder: Int
│
└── tags: [Tag]
    ├── id: UUID
    └── name: String (editierbar)
```

## Hinweise zum Datenmodell

- **Audio-Datei separat:** Die Audiodatei wird im lokalen Dateisystem gespeichert (nicht in SwiftData), um die Datenbank schlank zu halten. Nur die URL wird referenziert.
- **CloudKit-Sync:** Transkripte, Zusammenfassungen, Action-Items, Kapitel und Tags werden via CloudKit synchronisiert. Audiodateien werden **nicht** synchronisiert (zu groß, Privatsphäre).
- **Verarbeitungsstatus:** Ermöglicht der UI, den aktuellen Stand anzuzeigen (z.B. Ladeindikator während der Transkription). Der Status `llm_ausstehend` zeigt an, dass das Transkript vorliegt, die LLM-Aufbereitung aber noch aussteht – z.B. weil das Fallback-Modell noch nicht heruntergeladen wurde.
