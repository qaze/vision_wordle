import RealityKit
import UIKit

class LetterEntity: Entity, HasModel {
    private let textModel = TextEntity(
        text: "",
        color: .white,
        isLit: false,
        size: 0.05, 
        isMetallic: false
    )

    var color: UIColor = .blue {
        didSet { make() }
    }
    var letter: String {
        get { textModel.text }
        set { textModel.text = newValue }
    }

    required init() {
        super.init()
        make()
    }

    private func make() {
        let planeMesh = MeshResource
            .generatePlane(
                width: 0.08,
                height: 0.08,
                cornerRadius: 0.01
            )

        model = ModelComponent(
            mesh: planeMesh,
            materials: [makeMaterial()]
        )

        addChild(textModel)
        textModel.transform = .init(
            translation: .init(x: -0.015, y: -0.03, z: 0)
        )
    }

    private func makeMaterial() -> PhysicallyBasedMaterial {
        var planeMaterial = PhysicallyBasedMaterial()
        planeMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color)
        planeMaterial.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: 0.4)
        planeMaterial.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 0.6)
        planeMaterial.specular = .init(floatLiteral: 0.8)
        return planeMaterial
    }
}

