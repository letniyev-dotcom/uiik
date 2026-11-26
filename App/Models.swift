import Foundation

enum VpnStatus: Equatable {
    case off
    case connecting
    case on
}

struct Server: Identifiable, Equatable {
    let id: String
    var name: String
    var cc: String
    var host: String
    var port: Int
    /// Задержка в мс; -1 — недоступен; nil — ещё не измеряли (шаблон).
    var ping: Int?
}

struct Subscription: Identifiable, Equatable {
    let id: String
    var name: String
    var info: String
    var servers: [Server]
}

enum ThemeMode: Int { case system = -1, light = 0, dark = 1 }

// MARK: - Мок-данные для шаблона (сеть появится позже)

enum MockData {
    static let subscriptions: [Subscription] = [
        Subscription(
            id: "sub1", name: "Основная подписка",
            info: "12 ГБ из 50 ГБ · до 14 дек.",
            servers: [
                Server(id: "s1", name: "Нидерланды", cc: "NL", host: "nl.example.com", port: 443, ping: 42),
                Server(id: "s2", name: "Германия", cc: "DE", host: "de.example.com", port: 443, ping: 55),
                Server(id: "s3", name: "Финляндия", cc: "FI", host: "fi.example.com", port: 443, ping: -1),
            ]),
        Subscription(
            id: "sub2", name: "Запасная",
            info: "",
            servers: [
                Server(id: "s4", name: "Эстония", cc: "EE", host: "ee.example.com", port: 8443, ping: 78),
            ]),
    ]
}
