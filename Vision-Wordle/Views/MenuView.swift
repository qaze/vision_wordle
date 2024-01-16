import SwiftUI

struct MenuView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @State var isGameRunning = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Wordle")
                    .font(.title)

                Spacer()
                VStack {
                    if !isGameRunning {
                        Button(
                            action: {
                                Task {
                                    await openImmersiveSpace(id: Scenes.game)
                                    isGameRunning = true
                                }
                            },
                            label: {
                                Text("Play")
                            }
                        )
                        .padding()
                    } else {
                        Button(
                            action: {
                                Task {
                                    await dismissImmersiveSpace()
                                    isGameRunning = false
                                }
                            },
                            label: {
                                Text("Close game")
                            }
                        )
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding()
            .fixedSize()
        }
    }
}
