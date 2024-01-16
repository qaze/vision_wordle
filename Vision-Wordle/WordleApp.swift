import SwiftUI

enum Scenes {
    static let game = "game"
    static let menu = "menu"
}

@main
struct WordleApp: App {
    @State private var immersionStyle: ImmersionStyle = .mixed

    var body: some Scene {
        WindowGroup(id: Scenes.menu) {
            MenuView()
                .frame(width: 300, height: 300)
                .fixedSize()
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)

        ImmersiveSpace(id: Scenes.game) {
            WordleGame()
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed)
        .windowStyle(.volumetric)
        .windowResizability(.contentSize)
    }
}
