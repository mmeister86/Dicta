import Foundation

struct TranscriptItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let text: String
    let createdAt: Date
    let duration: TimeInterval
    let languageCode: String

    var previewText: String {
        let compact = text.replacingOccurrences(of: "\n", with: " ")
        return String(compact.prefix(100))
    }

    var durationText: String {
        TranscriptItem.formatDuration(duration)
    }

    static func formatDuration(_ value: TimeInterval) -> String {
        let totalSeconds = Int(value)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    static let mockItems: [TranscriptItem] = [
        TranscriptItem(
            id: UUID(),
            title: "Daily Standup",
            text: "Heute arbeiten wir am ersten UI-MVP fuer Dicta. Fokus liegt auf dem Kernfluss von Aufnahme zu Verlauf und dann in die Detailansicht.",
            createdAt: Date().addingTimeInterval(-60 * 45),
            duration: 142,
            languageCode: "de-DE"
        ),
        TranscriptItem(
            id: UUID(),
            title: "Ideensammlung Produkt",
            text: "Notiz: Navigation soll auf iPhone klar bleiben. Aufnahme braucht einen grossen, eindeutigen Einstieg und den aktuellen Status.",
            createdAt: Date().addingTimeInterval(-60 * 60 * 5),
            duration: 296,
            languageCode: "de-DE"
        ),
        TranscriptItem(
            id: UUID(),
            title: "Kundenfeedback",
            text: "Transkript aus Testinterview. Nutzer wuenschen sich schnelle Erfassung, spaetere Korrektur und saubere Metadaten in der Detailansicht.",
            createdAt: Date().addingTimeInterval(-60 * 60 * 26),
            duration: 408,
            languageCode: "de-DE"
        )
    ]
}
