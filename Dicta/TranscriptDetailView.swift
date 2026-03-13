import SwiftUI

struct TranscriptDetailView: View {
    let item: TranscriptItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(item.text)
                    .font(.body)
                    .textSelection(.enabled)

                VStack(alignment: .leading, spacing: 10) {
                    metadataRow(label: "Titel", value: item.title)
                    metadataRow(label: "Zeitpunkt", value: item.createdAt.formatted(date: .abbreviated, time: .shortened))
                    metadataRow(label: "Dauer", value: item.durationText)
                    metadataRow(label: "Sprache", value: item.languageCode)
                    metadataRow(label: "Woerter", value: "\(item.text.split(separator: " ").count)")
                }
                .font(.subheadline)

                Spacer(minLength: 0)
            }
            .padding(20)
        }
        .navigationTitle(item.title)
    }

    @ViewBuilder
    private func metadataRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        TranscriptDetailView(item: TranscriptItem.mockItems[0])
    }
}
