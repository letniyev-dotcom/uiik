import SwiftUI

struct SmartCard: View {
    @Environment(\.palette) var p
    @EnvironmentObject var state: AppState

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(p.primary)
                .frame(width: 44, height: 44)
                .background(p.tint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text("Умное подключение")
                    .font(.headline)
                    .foregroundStyle(p.text)
                Text("Сам выберет самый быстрый сервер и включится после перезагрузки")
                    .font(.footnote)
                    .foregroundStyle(p.text2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            Toggle("", isOn: $state.smart)
                .labelsHidden()
                .tint(p.primary)
        }
        .padding(16)
        .background(p.island, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: p.dark ? .black.opacity(0.4) : Color(hex: 0x783C50).opacity(0.10),
                radius: 12, x: 0, y: 6)
    }
}
