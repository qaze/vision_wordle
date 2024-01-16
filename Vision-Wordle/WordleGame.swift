import SwiftUI
import RealityKit
import RealityFoundation
import SceneKit
import Combine

struct WordleGame: View {
    @State var text = ""
    private let gameEntity = GameEntity()
    private let wordsProvider: WordsProvider = WordsProvider()

    @State private var previousDragValue: Vector3D?
    @State private var prePreviousDragValue: Vector3D?
    @State private var previousDragTime: Date = .now

    var body: some View {
        RealityView { content in
            CollisionComponent.registerComponent()
            HoverEffectComponent.registerComponent()
            PhysicsBodyComponent.registerComponent()

            let anchor = AnchorEntity(
                .plane(
                    .vertical,
                    classification: .wall,
                    minimumBounds: SIMD2<Float>(x: 1, y: 1)
                ),
                trackingMode: .continuous
            )

            content.add(anchor)
            anchor.addChild(gameEntity)
            gameEntity.transform = .init(
                rotation: .init(angle: -.pi / 2, axis: .init(x: 1, y: 0, z: 0))
            )
        } update: { content in
            gameEntity.updateText(text)
        }
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded({ @MainActor value in
                    guard let entity = value.entity as? LetterEntity else { return }
                    let letter = entity.letter
                    if letter == "↩" {
                        gameEntity.trySubmit()
                        text = ""
                    } else if letter == "⌫"{
                        text = String(text.dropLast())
                    } else {
                        text = String((text + letter).prefix(5))
                    }
                })
        )
    }
}
