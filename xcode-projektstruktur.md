# Xcode Projektstruktur – Sprachrekorder

> **Projekttyp:** Multiplatform App (SwiftUI)  
> **Plattformen:** iOS 26, iPadOS 26, macOS 26, watchOS 26  
> **Architektur:** MVVM  
> **Basierend auf:** PRD v1.1

---

## Projektübersicht

Das Projekt wird als **Xcode Multiplatform App** angelegt. Die Apple Watch wird als separates Target hinzugefügt. Ca. 80% des Codes liegt im `Shared/`-Ordner und wird von allen Plattformen genutzt. Plattformspezifische Ordner enthalten ausschließlich Navigation und Layout-Anpassungen – keine Geschäftslogik.

---

## Verzeichnisbaum

```
Sprachrekorder/                          ← Multiplatform App Target
│
├── SprachrekorderApp.swift              ← App Entry Point (@main), shared across platforms
│
├── Shared/                              ← ~80% des Codes, alle Plattformen
│   │
│   ├── Models/                          ← SwiftData @Model Definitionen
│   │   ├── Recording.swift              ← Hauptentität (Aufnahme)
│   │   ├── Transcript.swift             ← Rohtranskript
│   │   ├── Summary.swift                ← LLM-generierte Zusammenfassung
│   │   ├── ActionItem.swift             ← Extrahierte To-Dos
│   │   ├── Chapter.swift                ← Kapitelübersicht
│   │   ├── Tag.swift                    ← Automatische/manuelle Tags
│   │   └── ProcessingStatus.swift       ← Enum: aufgenommen, transkribiert, aufbereitet, llm_ausstehend
│   │
│   ├── Services/                        ← Business Logic Layer
│   │   │
│   │   ├── LLM/                         ← ⚠️ KI-Abstraktionsschicht (WICHTIG)
│   │   │   ├── LLMService.swift         ← protocol LLMService (summarize, extractActionItems, generateChapters, generateTags)
│   │   │   ├── FoundationModelsLLMService.swift  ← Implementierung für Apple Intelligence (primär)
│   │   │   ├── LlamaCppLLMService.swift          ← Implementierung via LLM.swift/llama.cpp (Fallback)
│   │   │   └── LLMServiceFactory.swift           ← Backend-Auswahl beim App-Start basierend auf Geräteverfügbarkeit
│   │   │
│   │   ├── Audio/
│   │   │   ├── AudioRecorderService.swift        ← AVAudioEngine Wrapper, Hintergrundaufnahme
│   │   │   └── AudioFileManager.swift            ← Speichern, Löschen, Dateipfade verwalten
│   │   │
│   │   ├── Transcription/
│   │   │   └── TranscriptionService.swift        ← WhisperKit Integration (On-Device STT)
│   │   │
│   │   ├── Export/
│   │   │   ├── MarkdownExporter.swift            ← Export als .md
│   │   │   └── PDFExporter.swift                 ← Export als .pdf
│   │   │
│   │   ├── Sync/                                 ← Phase 3
│   │   │   └── CloudKitSyncService.swift         ← CloudKit-Synchronisierung
│   │   │
│   │   └── ModelDownload/
│   │       └── ModelDownloadService.swift        ← Qwen3.5 on-demand Download (~500 MB), resumable
│   │
│   ├── ViewModels/                      ← MVVM – vollständig backend-agnostisch
│   │   ├── RecordingViewModel.swift     ← Aufnahme starten/stoppen/pausieren
│   │   ├── LibraryViewModel.swift       ← Aufnahmeliste + Suchfunktion
│   │   ├── DetailViewModel.swift        ← Detail-View mit Tabs (Transkript, Summary, Actions, Kapitel)
│   │   └── ProcessingViewModel.swift    ← STT + LLM Pipeline orchestrieren
│   │
│   ├── Views/                           ← Plattformübergreifende SwiftUI Views
│   │   ├── RecordingView.swift          ← Aufnahme-Button + Waveform-Anzeige
│   │   ├── LibraryListView.swift        ← Liste aller Aufnahmen
│   │   ├── RecordingDetailView.swift    ← Detail-Ansicht mit Tab-Wechsel
│   │   ├── TranscriptTabView.swift      ← Rohtranskript anzeigen
│   │   ├── SummaryTabView.swift         ← Zusammenfassung anzeigen/bearbeiten
│   │   ├── ActionItemsTabView.swift     ← Action-Items anzeigen/bearbeiten/abhaken
│   │   ├── ChaptersTabView.swift        ← Kapitelübersicht
│   │   ├── SearchView.swift             ← Volltextsuche über alle Inhalte
│   │   ├── ExportSheet.swift            ← Export-Dialog (Markdown/PDF)
│   │   ├── ModelDownloadView.swift      ← Fallback-Modell Download UI mit Fortschrittsanzeige
│   │   └── ProcessingOverlayView.swift  ← Fortschrittsanzeige während STT/LLM-Verarbeitung
│   │
│   └── Utilities/
│       ├── DeviceCapabilities.swift     ← Prüft Apple Intelligence Verfügbarkeit (SystemLanguageModel.default.availability)
│       ├── Constants.swift              ← App-weite Konstanten
│       └── Extensions/
│           ├── Date+Formatting.swift    ← Datums-Formatierung
│           └── String+Markdown.swift    ← Markdown-Hilfsfunktionen
│
├── iOS/                                 ← iPhone + iPad spezifisch
│   ├── iOSContentView.swift             ← Entscheidet: TabView (iPhone) vs. Sidebar (iPad)
│   ├── iPhoneTabNavigation.swift        ← TabBar-Navigation für iPhone
│   ├── iPadSidebarNavigation.swift      ← Sidebar-Navigation für iPad
│   └── Info.plist                       ← ⚠️ WICHTIG: Background Audio Mode + NSMicrophoneUsageDescription
│
├── macOS/                               ← Mac spezifisch
│   ├── macOSContentView.swift           ← NavigationSplitView + Toolbar
│   └── macOSCommands.swift              ← Menüleisten-Einträge (Shortcuts, Preferences)
│
└── Resources/
    ├── Assets.xcassets                  ← App Icons, Akzentfarben, Bilder
    ├── Localizable.xcstrings            ← Lokalisierung: Deutsch + Englisch
    └── Sprachrekorder.entitlements      ← ⚠️ WICHTIG: iCloud (CloudKit), App Groups


SprachrekorderWatch/                     ← Separates watchOS Target
├── SprachrekorderWatchApp.swift         ← @main Watch App Entry Point
├── WatchRecordingView.swift             ← Start/Stop Aufnahme auf der Watch
├── WatchLibraryView.swift               ← Kompakte Übersicht: Titel, Tags, Zusammenfassung (gekürzt)
├── WatchConnectivityService.swift       ← ⚠️ WICHTIG: Audio-Transfer Watch → iPhone (transferFile)
├── Assets.xcassets                      ← Watch-spezifische Icons
└── Info.plist                           ← Watch-Konfiguration


Package Dependencies/ (SPM)
├── WhisperKit                           ← On-Device Speech-to-Text → nur iOS + macOS Target
└── LLM.swift                            ← llama.cpp Fallback-LLM → nur iOS + macOS Target
```

---

## Architekturentscheidungen

### LLMService-Protokoll (zentrale Abstraktionsschicht)

```swift
protocol LLMService {
    func summarize(_ transcript: String) async throws -> String
    func extractActionItems(_ transcript: String) async throws -> [String]
    func generateChapters(_ transcript: String) async throws -> [Chapter]
    func generateTags(_ transcript: String) async throws -> [String]
}
```

- **FoundationModelsLLMService** → Apple Intelligence (primär, kein Download nötig)
- **LlamaCppLLMService** → LLM.swift / llama.cpp + Qwen3.5-0.8B (Fallback, ~500 MB on-demand Download)
- **LLMServiceFactory** → Wählt beim App-Start das Backend basierend auf `SystemLanguageModel.default.availability`
- ViewModels und Views sind vollständig backend-agnostisch

### Gerätesegmentierung

| Geräteklasse | LLM-Backend | Modell-Download |
|---|---|---|
| Apple Intelligence verfügbar & aktiviert (iPhone 15 Pro+, M1+) | Foundation Models (System) | Keiner nötig |
| Apple Intelligence deaktiviert oder nicht verfügbar (iPhone 12–15 non-Pro) | LLM.swift + Qwen3.5-0.8B | On-Demand (~500 MB) |

### Datenmodell (SwiftData)

```
Recording
├── id: UUID
├── title: String (LLM-generiert, editierbar)
├── createdAt: Date
├── duration: TimeInterval
├── audioFileURL: URL? (optional, nach Löschfrage)
├── processingStatus: Enum (aufgenommen, transkribiert, aufbereitet, llm_ausstehend)
├── transcript: Transcript (id, rawText, language)
├── summary: Summary (id, text – editierbar)
├── actionItems: [ActionItem] (id, text, isCompleted, sortOrder – editierbar)
├── chapters: [Chapter] (id, title, summary, sortOrder)
└── tags: [Tag] (id, name – editierbar)
```

- Audiodateien im Dateisystem, nur URL in SwiftData (Datenbank schlank halten)
- CloudKit synchronisiert nur Textdaten, keine Audiodateien
- Status `llm_ausstehend` = Transkript vorhanden, LLM-Aufbereitung steht noch aus

---

## Kritische Konfigurationen

### iOS Info.plist

- `UIBackgroundModes`: `audio` (Hintergrundaufnahme)
- `NSMicrophoneUsageDescription`: Verständliche Beschreibung für Permission-Dialog

### Entitlements (Sprachrekorder.entitlements)

- iCloud → CloudKit Container (frühzeitig im Developer Portal anlegen)
- App Groups (für Watch ↔ iPhone Datenaustausch)

### SPM Package-Zuordnung

- **WhisperKit** → nur iOS-Target + macOS-Target (Watch braucht es nicht)
- **LLM.swift** → nur iOS-Target + macOS-Target (Watch braucht es nicht)

### Bundle-IDs

- iOS/macOS: `com.name.sprachrekorder`
- watchOS: `com.name.sprachrekorder.watchkitapp`
- Universal Purchase: Alle Targets unter demselben Apple-Developer-Team

---

## Entwicklungsphasen-Zuordnung

| Phase | Umfang | Dauer |
|---|---|---|
| Phase 1: Prototyp | Audio-Aufnahme (Vorder-/Hintergrund), WhisperKit-Integration, einfache UI, SwiftData | 4–6 Wochen |
| Phase 2: MVP/Alpha | Foundation Models + LLM.swift Fallback, vollständige Detail-View, Bearbeitung, Bibliothek, Suche, iPad-Layout | 6–8 Wochen |
| Phase 3: Beta | CloudKit-Sync, macOS-App, Apple Watch, Export (MD/PDF), Lokalisierung (DE+EN) | 4–6 Wochen |
| Phase 4: Launch | Performance, Bugfixing, App Store Listing, Review | 2–4 Wochen |

---

## Hinweise zur Struktur

1. `Shared/` enthält ~80% des Codes – Models, Services, ViewModels und gemeinsame Views werden von allen Targets genutzt.
2. `LLMService` ist das zentrale Protokoll. `FoundationModelsLLMService` und `LlamaCppLLMService` implementieren es – ViewModels bleiben backend-agnostisch.
3. WhisperKit und LLM.swift werden via SPM nur den iOS- und macOS-Targets zugewiesen – die Watch braucht sie nicht.
4. Plattformspezifische Ordner (`iOS/`, `macOS/`, `watchOS/`) enthalten nur Navigation und Layout-Anpassungen – keine Geschäftslogik.
5. CloudKit-Container frühzeitig im Developer Portal anlegen, auch wenn Sync erst in Phase 3 kommt.
6. Background Audio Mode und `NSMicrophoneUsageDescription` im iOS-Target nicht vergessen.
7. Bundle-ID-Basis einheitlich halten: `com.name.sprachrekorder` (iOS/macOS) und `.watchkitapp` als Suffix für die Watch.
