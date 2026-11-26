import SwiftUI

struct SubsCard: View {
    @Environment(\.palette) var p
    @EnvironmentObject var state: AppState
    @Binding var showAddSheet: Bool
    @Binding var editMode: EditMode

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Подписки")
                    .font(.headline)
                    .foregroundStyle(p.text)
                Spacer()
                Button { showAddSheet = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(p.onPrimary)
                        .frame(width: 30, height: 30)
                        .background(p.primary, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Добавить подписку")
            }

            if state.subs.isEmpty {
                Text("Нажмите «+», чтобы добавить подписку из буфера обмена")
                    .font(.footnote)
                    .foregroundStyle(p.text2)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            } else {
                ForEach(state.subs) { sub in
                    SubscriptionBlock(sub: sub, editMode: editMode)
                }
                .onMove { from, to in state.subs.move(fromOffsets: from, toOffset: to) }
            }
        }
        .padding(16)
        .background(p.island, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: p.dark ? .black.opacity(0.4) : Color(hex: 0x783C50).opacity(0.10),
                radius: 12, x: 0, y: 6)
    }
}

struct SubscriptionBlock: View {
    @Environment(\.palette) var p
    @EnvironmentObject var state: AppState
    let sub: Subscription
    let editMode: EditMode

    private var isOpen: Bool { state.opened.contains(sub.id) }

    var body: some View {
        VStack(spacing: 0) {
            Button { withAnimation(.easeInOut(duration: 0.25)) { state.toggleOpen(sub.id) } } label: {
                HStack(spacing: 12) {
                    if editMode == .active {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(p.text2)
                    }
                    Avatar(sub: sub)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(sub.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(p.text)
                        if !sub.info.isEmpty {
                            Text(sub.info)
                                .font(.caption)
                                .foregroundStyle(p.text2)
                        }
                    }
                    Spacer()
                    Text(pluralServers(sub.servers.count))
                        .font(.caption)
                        .foregroundStyle(p.text2)
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(p.text2)
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isOpen {
                VStack(spacing: 8) {
                    ForEach(sub.servers) { server in
                        ServerRow(server: server)
                    }
                }
                .padding(.bottom, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, 12)
        .background(p.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct Avatar: View {
    @Environment(\.palette) var p
    let sub: Subscription

    var body: some View {
        Text(String(sub.name.first ?? "+"))
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(p.primary)
            .frame(width: 38, height: 38)
            .background(p.tint, in: Circle())
    }
}

struct ServerRow: View {
    @Environment(\.palette) var p
    @EnvironmentObject var state: AppState
    let server: Server

    private var selected: Bool { state.selectedServerId == server.id && !state.smart }

    var body: some View {
        Button { state.select(server.id) } label: {
            HStack(spacing: 10) {
                Text(flag(server.cc))
                    .font(.system(size: 22))
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 1) {
                    Text(server.name)
                        .font(.subheadline)
                        .foregroundStyle(p.text)
                    Text("\(server.host):\(server.port)")
                        .font(.caption2)
                        .foregroundStyle(p.text2)
                }
                Spacer()
                Text(pingText)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(pingColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(selected ? p.primary.opacity(0.15) : p.bg,
                                 in: Capsule())
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(selected ? p.tint : p.island,
                        in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(selected ? p.primary : .clear, lineWidth: 1.5)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var pingText: String {
        guard let ping = server.ping else { return "—" }
        return ping > 0 ? "\(ping) мс" : "недоступен"
    }
    private var pingColor: Color {
        guard let ping = server.ping, ping > 0 else { return p.text2 }
        return p.text
    }
}

func pluralServers(_ n: Int) -> String {
    let mod100 = n % 100, mod10 = n % 10
    if mod100 >= 11 && mod100 <= 14 { return "\(n) серверов" }
    switch mod10 {
    case 1: return "\(n) сервер"
    case 2, 3, 4: return "\(n) сервера"
    default: return "\(n) серверов"
    }
}
