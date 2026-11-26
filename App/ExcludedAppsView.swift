import SwiftUI

struct ExcludedAppsView: View {
    @Environment(\.palette) var p
    @Environment(\.dismiss) var dismiss
    /// Пакеты приложений, чей трафик пойдёт мимо VPN.
    /// На iOS список формирует сам пользователь — система не даёт перечислить чужие приложения.
    @State private var excluded: Set<String> = []
    @State private var newBundleId: String = ""

    var body: some View {
        NavigationStack {
            ZStack { p.bg.ignoresSafeArea()
                List {
                    Section {
                        HStack {
                            TextField("Bundle ID, напр. com.bank.app", text: $newBundleId)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            Button {
                                let id = newBundleId.trimmingCharacters(in: .whitespaces)
                                guard !id.isEmpty else { return }
                                excluded.insert(id)
                                newBundleId = ""
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(p.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Добавить приложение")
                    } footer: {
                        Text("Трафик добавленных приложений пойдёт мимо VPN. Применяется при следующем подключении.")
                    }
                    if !excluded.isEmpty {
                        Section("Приложения без VPN") {
                            ForEach(sortedExcluded, id: \.self) { id in
                                HStack {
                                    Text(id).font(.subheadline)
                                    Spacer()
                                    Button {
                                        excluded.remove(id)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(p.primary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Исключения")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                        .foregroundStyle(p.primary)
                }
            }
        }
    }

    private var sortedExcluded: [String] { excluded.sorted() }
}
