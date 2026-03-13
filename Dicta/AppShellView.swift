import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            RecordView()
                .tabItem {
                    Label("Aufnahme", systemImage: "mic.fill")
                }

            TranscriptListView()
                .tabItem {
                    Label("Verlauf", systemImage: "text.page")
                }
        }
    }
}

#Preview {
    AppShellView()
}
