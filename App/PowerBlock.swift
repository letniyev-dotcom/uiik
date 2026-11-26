import SwiftUI

struct PowerBlock: View {
    @Environment(\.palette) var p
    @EnvironmentObject var state: AppState

    private var statusText: String {
        switch state.vpn {
        case .off: return "Отключено"
        case .connecting: return "Подключение…"
        case .on: return "Подключено"
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                // Кольцо-индикатор
                Circle()
                    .stroke(p.surface, lineWidth: 10)
                Circle()
                    .trim(from: 0, to: state.vpn == .off ? 0 : 1)
                    .stroke(p.primary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: state.vpn)
                // Объёмное стекло, как в прототипе
                Circle()
                    .fill(
                        LinearGradient(colors: [p.island, p.surface],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: p.dark ? .black.opacity(0.5) : Color(hex: 0x783C50).opacity(0.12),
                            radius: 16, x: 0, y: 8)
                    .padding(14)
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { state.togglePower() }
                } label: {
                    Image(systemName: "power")
                        .font(.system(size: 54, weight: .semibold))
                        .foregroundStyle(state.vpn == .off ? p.text2 : p.primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
                .disabled(state.vpn == .connecting)
            }
            .frame(width: 216, height: 216)

            Text(statusText)
                .font(.title2.weight(.semibold))
                .foregroundStyle(p.text)
            if let s = state.currentServer {
                Text("\(flag(s.cc)) \(s.name) · \((s.ping ?? -1) > 0 ? "\(s.ping!) мс" : "—")")
                    .font(.subheadline)
                    .foregroundStyle(p.text2)
            }
            Text(state.vpn == .off ? "Нажмите, чтобы подключиться" : "")
                .font(.footnote)
                .foregroundStyle(p.text2)
        }
        .padding(.vertical, 8)
    }
}

func flag(_ cc: String) -> String {
    guard cc.count == 2 else { return "" }
    return cc.uppercased().unicodeScalars.reduce(into: "") {
        let v = $1.value
        guard (65...90).contains(v), let scalar = UnicodeScalar(0x1F1E6 + v - 65) else { return }
        $0.unicodeScalars.append(scalar)
    }
}
