import SwiftUI

/// Палитра 1 в 1 из прототипа letnievpn, адаптированная под iOS.
struct Palette {
    let dark: Bool
    let primary: Color
    let onPrimary: Color
    let bg: Color
    let surface: Color
    let island: Color
    let text: Color
    let text2: Color
    let tint: Color
}

extension Palette {
    static let light = Palette(
        dark: false,
        primary: Color(hex: 0xD4527F),
        onPrimary: .white,
        bg: Color(hex: 0xFBF4F5),
        surface: Color(hex: 0xF3E8EB),
        island: Color(hex: 0xFFFDFD),
        text: Color(hex: 0x25181C),
        text2: Color(hex: 0x85727A),
        tint: Color(hex: 0xD4527F).opacity(0.12)
    )
    static let dark = Palette(
        dark: true,
        primary: Color(hex: 0xF4A6C0),
        onPrimary: Color(hex: 0x2A0E18),
        bg: Color(hex: 0x111111),
        surface: Color(hex: 0x1C1C1C),
        island: Color(hex: 0x262626),
        text: Color(hex: 0xEDEDED),
        text2: Color(hex: 0x9A9A9A),
        tint: Color(hex: 0xF4A6C0).opacity(0.14)
    )
}

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: 1)
    }
}

private struct PaletteKey: EnvironmentKey {
    static let defaultValue = Palette.light
}
extension EnvironmentValues {
    var palette: Palette {
        get { self[PaletteKey.self] }
        set { self[PaletteKey.self] = newValue }
    }
}

struct LetnieTheme: ViewModifier {
    @ObservedObject var state: AppState
    func body(content: Content) -> some View {
        let dark: Bool = {
            switch state.themeMode {
            case .system: return UITraitCollection.current.userInterfaceStyle == .dark
            case .light: return false
            case .dark: return true
            }
        }()
        let p = dark ? Palette.dark : Palette.light
        return content
            .environment(\.palette, p)
            .preferredColorScheme(dark ? .dark : .light)
            .tint(p.primary)
            .background(p.bg.ignoresSafeArea())
    }
}
extension View {
    func letnieTheme(_ state: AppState) -> some View { modifier(LetnieTheme(state: state)) }
}
