import SwiftUI
import Combine

/// Общее состояние приложения. Сейчас — только дизайн-шаблон: данные моковые,
/// сетевой слой (подписки, пинг, туннель) подключим позже.
final class AppState: ObservableObject {
    @Published var vpn: VpnStatus = .off
    @Published var smart = true
    @Published var themeMode: ThemeMode = .system

    @Published var subs: [Subscription] = MockData.subscriptions
    @Published var opened: Set<String> = []
    @Published var selectedServerId: String? = "s1"

    /// Сервер, к которому сейчас «подключены» (умный режим — первый из списка).
    var currentServer: Server? {
        if smart { return subs.flatMap(\.servers).first { $0.ping ?? -1 > 0 } ?? subs.flatMap(\.servers).first }
        return subs.flatMap(\.servers).first { $0.id == selectedServerId }
    }

    // MARK: Действия (пока только локальные)
    func togglePower() {
        switch vpn {
        case .off: vpn = .connecting
        case .connecting: vpn = .off
        case .on: vpn = .off
        }
        // Шаблон: через 1,5 с «подключаемся»
        if vpn == .connecting {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                if self?.vpn == .connecting { self?.vpn = .on }
            }
        }
    }

    func select(_ id: String) {
        selectedServerId = id
        smart = false
    }

    func toggleOpen(_ id: String) {
        if opened.contains(id) { opened.remove(id) } else { opened.insert(id) }
    }
}
