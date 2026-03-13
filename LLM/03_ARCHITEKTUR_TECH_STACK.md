# Architektur & Tech-Stack

> **Quelle:** PRD v1.1, Abschnitt 4

---

## Plattformstrategie

| Plattform | Rolle | Minimum OS |
|-----------|-------|-----------|
| iPhone | Primäres Gerät – Aufnahme, Verarbeitung, vollständige UI | iOS 26 |
| iPad | Vollständige UI mit optimiertem Layout | iPadOS 26 |
| macOS | Vollständige UI als native Mac-App | macOS 26 |
| Apple Watch | Remote-Mikrofon, kompakte Übersicht | watchOS 26 |

## Tech-Stack

| Komponente | Technologie | Begründung |
|-----------|------------|-----------|
| UI-Framework | SwiftUI | Native Cross-Platform innerhalb des Apple-Ökosystems, einheitliche Codebasis |
| Sprache | Swift | Standard für Apple-Plattformen, modernste Sprachfeatures |
| Transkription | WhisperKit | On-Device Speech-to-Text, optimiert für Apple Silicon |
| KI-Aufbereitung (Primär) | Apple Foundation Models (iOS 26+, Apple Intelligence erforderlich) | On-Device LLM des Systems – kein Download, optimale Performance |
| KI-Aufbereitung (Fallback) | LLM.swift via llama.cpp + Qwen3.5-0.8B (GGUF) | On-Device LLM für Geräte ohne Apple Intelligence; Qwen3.5-0.8B mit 262K-Token-Kontextfenster, on-demand downloadbar (~500 MB) |
| LLM-Abstraktionsschicht | `LLMService`-Protokoll (intern) | Einheitliches Interface für beide LLM-Backends; ViewModels bleiben backend-agnostisch |
| Persistenz (lokal) | SwiftData | Modernes, Swift-natives Persistenz-Framework, Nachfolger von Core Data |
| Synchronisierung | CloudKit | Nahtlose Sync über Apple-Geräte, kein eigener Backend-Server nötig |
| Audio-Engine | AVFAudioEngine / AVAudioRecorder | System-Framework für Hintergrundaufnahme mit Background Audio Mode |
| Watch-Kommunikation | WatchConnectivity | Datentransfer zwischen Watch und iPhone |
| Export | Swift-native PDF-Generierung + Markdown-String-Generierung | Keine externen Abhängigkeiten |

## Architekturdiagramm (konzeptionell)

```
┌─────────────────────────────────────────────────────┐
│                   Apple Watch                        │
│  ┌────────────┐  WatchConnectivity  ┌─────────────┐ │
│  │ Audio Rec.  │ ──────────────────► │  Companion   │ │
│  │ (Mikrofon)  │                     │  (iPhone)    │ │
│  └────────────┘                     └─────────────┘ │
└─────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│          iPhone / iPad / macOS                            │
│                                                           │
│  ┌──────────┐    ┌─────────────┐    ┌─────────────────┐  │
│  │  Audio    │───►│ WhisperKit  │───►│   LLMService    │  │
│  │ Recording │    │ (STT)       │    │   (Protokoll)   │  │
│  └──────────┘    └─────────────┘    └────────┬────────┘  │
│                                              │            │
│                              ┌───────────────┴──────────┐ │
│                              │                          │ │
│                    ┌─────────▼──────┐  ┌───────────────▼┐│
│                    │ Foundation      │  │ LLM.swift      ││
│                    │ Models          │  │ (llama.cpp)    ││
│                    │ (Apple Intell.) │  │ [Fallback]     ││
│                    └─────────┬──────┘  └───────────┬───┘│
│                              └──────────┬───────────┘    │
│                                         │                 │
│                                ┌────────▼───────┐        │
│                                │   SwiftData    │        │
│                                │   (Lokal)      │        │
│                                └────────┬───────┘        │
│                                         │                 │
│                                ┌────────▼───────┐        │
│                                │   CloudKit     │        │
│                                │   (Sync)       │        │
│                                └────────────────┘        │
│                                                           │
│  ┌───────────────────────────────────────────────────┐   │
│  │              SwiftUI Views                         │   │
│  │  Aufnahme │ Liste │ Detail (Tabs: Transkript,     │   │
│  │           │       │ Zusammenfassung, Actions,      │   │
│  │           │       │ Kapitel) │ Suche │ Export       │   │
│  └───────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

## Architekturentscheidungen

- **Kein eigener Backend-Server:** Durch den vollständigen On-Device-Ansatz und CloudKit als Sync-Lösung entfallen Serverkosten und Wartungsaufwand komplett. Das unterstützt auch das Einmalkauf-Geschäftsmodell.
- **SwiftData statt Core Data:** SwiftData bietet native Swift-Integration, weniger Boilerplate und eingebaute CloudKit-Sync-Unterstützung.
- **MVVM-Architektur:** Empfohlen wird eine klare Trennung in Models, ViewModels und Views, um Testbarkeit und Wartbarkeit sicherzustellen.
- **LLMService-Protokoll als Abstraktionsschicht:** Beide LLM-Backends (Foundation Models und LLM.swift) werden hinter einem einheitlichen Swift-Protokoll gekapselt. ViewModels und Views sind damit vollständig backend-agnostisch – der Wechsel zwischen Primär- und Fallback-Pfad findet ausschließlich in der Initialisierungslogik statt.
