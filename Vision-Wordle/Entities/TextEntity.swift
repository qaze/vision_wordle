import RealityKit
import UIKit

class TextEntity: Entity, HasModel {
    var text: String = "" {
        didSet { if oldValue != text { setText(text) } }
    }

    private var color: UIColor = .black
    private var isLit = false
    private var size: CGFloat = .zero
    private var isMetallic = false

    required init() {
        super.init()
    }

    init(
        text: String,
        color: UIColor,
        isLit: Bool,
        size: CGFloat,
        isMetallic: Bool
    ) {
        super.init()

        self.text = text
        self.color = color
        self.isLit = isLit
        self.size = size
        self.isMetallic = isMetallic

        self.model = makeTextModel(
            text: text,
            color: color,
            isLit: isLit,
            size: size,
            isMetallic: isMetallic
        )
    }

    private func makeTextModel(
        text: String,
        color: UIColor,
        isLit: Bool,
        size: CGFloat,
        isMetallic: Bool
    ) -> ModelComponent {
        let textMesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.01,
            font: UIFont.systemFont(ofSize: size),
            containerFrame: .zero,
            alignment: .natural,
            lineBreakMode: .byTruncatingTail
        )

        let textMaterial: Material
        if isLit {
            textMaterial = SimpleMaterial(color: color, isMetallic: isMetallic)
        } else {
            textMaterial = UnlitMaterial(color: color)
        }

        return ModelComponent(mesh: textMesh, materials: [textMaterial])
    }

    private func setText(_ text: String) {
        model?.mesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.01,
            font: UIFont.systemFont(ofSize: size),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byTruncatingTail
        )
    }
}

