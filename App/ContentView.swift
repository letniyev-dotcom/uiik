import SwiftUI

struct ContentView: View {
    @Environment(\.palette) var p
    @EnvironmentObject var state: AppState
    @State private var showAddSheet = false
    @State private var showExcluded = false
    @State private var editMode = EditMode.inactive

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    PowerBlock()
                    SmartCard()
                    SubsCard(
                        showAddSheet: $showAddSheet,
                        editMode: $editMode
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .background(p.bg)
            .navigationTitle("letnievpn")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    themeToggle
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button { showExcluded = true } label: {
                            Label("Исключения", systemImage: "app.badge")
                        }
                        Button { editMode = editMode == .active ? .inactive : .active } label: {
                            Label(editMode == .active ? "Готово" : "Изменить порядок",
                                  systemImage: "arrow.up.arrow.down")
                        }
                    } label: { Image(systemName: "ellipsis.circle") }
                }
            }
            .sheet(isPresented: $showAddSheet) { AddSubscriptionSheet() }
            .sheet(isPresented: $showExcluded) { ExcludedAppsView() }
            .environment(\.editMode, $editMode)
        }
    }

    private var themeToggle: some View {
        Button {
            withAnimation {
                switch state.themeMode {
                case .system: state.themeMode = UITraitCollection.current.userInterfaceStyle == .dark ? .light : .dark
                case .light: state.themeMode = .dark
                case .dark: state.themeMode = .light
                }
            }
        } label: {
            Image(systemName: state.themeMode == .dark ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(p.primary)
        }
    }
}
