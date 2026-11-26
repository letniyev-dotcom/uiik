import SwiftUI

struct AddSubscriptionSheet: View {
    @Environment(\.palette) var p
    @Environment(\.dismiss) var dismiss
    @State private var url: String = ""

    var body: some View {
        NavigationStack {
            ZStack { p.bg.ignoresSafeArea()
                VStack(spacing: 16) {
                    TextField("https://…", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(14)
                        .background(p.island, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    Button {
                        // Шаблон: сеть будет позже — просто закрываем
                        dismiss()
                    } label: {
                        Text("Добавить")
                            .font(.headline)
                            .foregroundStyle(p.onPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(p.primary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    Button { dismiss() } label: {
                        Text("Добавить из буфера обмена")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(p.primary)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(16)
            }
            .navigationTitle("Добавить подписку")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                        .foregroundStyle(p.primary)
                }
            }
        }
    }
}
