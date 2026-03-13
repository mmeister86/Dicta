# LLM-Gerätestrategie & Fallback

> **Quelle:** PRD v1.1, Abschnitt 4a

---

## Hintergrund

Das Foundation Models Framework setzt voraus, dass auf dem Gerät **Apple Intelligence aktiviert** ist. Apple Intelligence ist hardwareseitig auf Geräte mit A17 Pro-Chip oder neuer (iPhone 15 Pro / 16-Serie) sowie alle Apple-Silicon-Macs (M1+) und iPads mit M-Chip beschränkt. Geräte innerhalb der iOS-26-Zielgruppe, die diese Voraussetzung nicht erfüllen – z.B. iPhone 12 bis 15 (non-Pro) – würden ohne Fallback-Strategie keine intelligente Aufbereitung erhalten.

Da sich die App bewusst an ein breites Publikum richtet, muss die intelligente Aufbereitung auch auf diesen Geräten vollständig on-device und privat funktionieren.

## Gerätesegmentierung

| Geräteklasse | Beispielgeräte | LLM-Backend | Modell-Download |
|---|---|---|---|
| Apple Intelligence verfügbar & aktiviert | iPhone 15 Pro+, iPhone 16+, iPad M1+, alle M-Macs | Foundation Models (System) | Kein Download nötig |
| Apple Intelligence hardwareseitig verfügbar, aber deaktiviert | Wie oben, AI in Settings deaktiviert | LLM.swift + Qwen3.5 (Fallback) | On-Demand (~500 MB) |
| Kein Apple Intelligence (ältere Hardware, ≥ A12) | iPhone 12–15 (non-Pro), ältere iPads | LLM.swift + Qwen3.5 (Fallback) | On-Demand (~500 MB) |

> **Hinweis:** WhisperKit für die Transkription ist von Apple Intelligence vollständig unabhängig und läuft auf allen unterstützten Geräten.

## Fallback-Implementierung: LLM.swift + Qwen3.5

Als Fallback-Backend wird **LLM.swift** eingesetzt, ein Swift-Package auf Basis von llama.cpp. LLM.swift läuft über den Metal-Stack und unterstützt die breite iOS-Gerätebasis ab A12-Chip.

**Einbindung via Swift Package Manager:**
```swift
.package(url: "https://github.com/eastriverlee/LLM.swift", branch: "main")
```

**Empfohlenes Fallback-Modell: `Qwen3.5-0.8B (Q4_K_M, GGUF)`** – ca. 500 MB, von Alibaba im März 2026 als Teil der Qwen3.5 Small Model Series veröffentlicht, Apache-2.0-lizenziert.

### Vorteile gegenüber älteren Alternativen

- **Massiv größeres Kontextfenster:** 262.144 Tokens nativ – das ist 64× mehr als Apple Foundation Models (4.096 Tokens). Selbst sehr lange Transkripte passen vollständig in einen einzigen Inference-Aufruf; Chunking entfällt im Fallback-Pfad.
- **Effiziente Hybrid-Architektur:** Gated Delta Networks kombiniert mit sparse MoE liefern hohen Durchsatz bei minimalem Latenz-Overhead – besser als reine Attention-Architekturen bei gleichem RAM-Bedarf.
- **Starke Instruction-Following-Performance:** IFEval 52,1 im Non-Thinking-Mode; ausreichend für strukturierte Aufgaben wie Summarization, Tag-Extraktion und Action-Items.
- **Upgrade-Pfad:** `Qwen3.5-2B (Q4_K_M, GGUF)` (~1,2 GB) zeigt deutlich bessere IFEval-Werte (61,2) und eignet sich für iPhone 14/15 (non-Pro) mit 6 GB RAM als optionaler Download.

Das Modell wird beim ersten Bedarf on-demand heruntergeladen und lokal gecacht.

**Integrations-Snippet:**
```swift
let bot = await LLM(from: HuggingFaceModel(
    "Qwen/Qwen3.5-0.8B-GGUF",
    .Q4_K_M,
    template: .chatML(systemPrompt)
))
```

### Modell-Auswahlstrategie

| Gerät | RAM | Standard-Fallback | Optionaler Upgrade |
|---|---|---|---|
| iPhone 12/13 | 4 GB | Qwen3.5-0.8B Q4_K_M (~500 MB) | — |
| iPhone 14/15 (non-Pro) | 6 GB | Qwen3.5-0.8B Q4_K_M (~500 MB) | Qwen3.5-2B Q4_K_M (~1,2 GB) |

## LLMService-Protokoll (Abstraktionsschicht)

Beide Backends werden hinter einem einheitlichen `LLMService`-Protokoll abstrahiert, sodass der gesamte ViewModel- und View-Code backend-agnostisch bleibt:

```swift
protocol LLMService {
    func summarize(_ transcript: String) async throws -> String
    func extractActionItems(_ transcript: String) async throws -> [String]
    func generateChapters(_ transcript: String) async throws -> [Chapter]
    func generateTags(_ transcript: String) async throws -> [String]
}

// Konkrete Implementierungen:
// FoundationModelsLLMService  → wraps Apple Foundation Models
// LlamaCppLLMService          → wraps LLM.swift / llama.cpp
```

Die Auswahl des aktiven Backends erfolgt einmalig beim App-Start anhand von `SystemLanguageModel.default.availability`.

## UX-Verhalten bei fehlendem LLM-Backend

Wenn das Fallback-Modell noch nicht heruntergeladen wurde, zeigt die App nach der Transkription einen einmaligen Hinweis:

> *„Für die intelligente Aufbereitung wird ein kleines KI-Modell (~500 MB) benötigt. Einmalig herunterladen?"*

Nach dem Download erfolgt die Aufbereitung vollständig lokal – identisch zur Foundation-Models-Experience. Die App ist bis zum Download vollständig nutzbar; nur die Aufbereitung steht noch aus und kann später nachgeholt werden.
