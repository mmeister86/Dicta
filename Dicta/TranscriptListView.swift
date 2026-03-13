import SwiftUI

struct TranscriptListView: View {
    private let items = TranscriptItem.mockItems

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(value: item) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title)
                            .font(.headline)

                        Text(item.previewText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)

                        Text("\(item.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))  |  \(item.durationText)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Verlauf")
            .navigationDestination(for: TranscriptItem.self) { item in
                TranscriptDetailView(item: item)
            }
        }
    }
}

#Preview {
    TranscriptListView()
}
