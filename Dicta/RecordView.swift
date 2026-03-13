import SwiftUI
import Combine

struct RecordView: View {
    private enum RecordingStatus: String {
        case idle = "Idle"
        case recording = "Recording"
        case paused = "Paused"

        var color: Color {
            switch self {
            case .idle:
                return .secondary
            case .recording:
                return .red
            case .paused:
                return .orange
            }
        }

        var icon: String {
            switch self {
            case .idle:
                return "mic.fill"
            case .recording:
                return "pause.fill"
            case .paused:
                return "play.fill"
            }
        }
    }

    @State private var status: RecordingStatus = .idle
    @State private var elapsed: TimeInterval = 0

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                statusBadge

                Text(TranscriptItem.formatDuration(elapsed))
                    .font(.system(size: 52, weight: .semibold, design: .rounded))
                    .monospacedDigit()

                Button(action: toggleRecording) {
                    Image(systemName: status.icon)
                        .font(.system(size: 46, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 144, height: 144)
                        .background(status.color, in: Circle())
                }
                .buttonStyle(.plain)

                if status != .idle {
                    Button("Stop") {
                        stopRecording()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .navigationTitle("Aufnahme")
            .onReceive(ticker) { _ in
                guard status == .recording else { return }
                elapsed += 1
            }
        }
    }

    private var statusBadge: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            Text(status.rawValue)
                .font(.headline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.thinMaterial, in: Capsule())
    }

    private func toggleRecording() {
        switch status {
        case .idle, .paused:
            status = .recording
        case .recording:
            status = .paused
        }
    }

    private func stopRecording() {
        status = .idle
        elapsed = 0
    }
}

#Preview {
    RecordView()
}
