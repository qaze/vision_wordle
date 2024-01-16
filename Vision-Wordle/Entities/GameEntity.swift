import RealityKit
import UIKit

class GameEntity: Entity {
    private lazy var word = try! wordsProvider.getWord()
    private var currentLine = 0
    private let wordsProvider = WordsProvider()

    required public init() {
        super.init()
        make()
    }

    init(wordsProvider: WordsProvider) {
        super.init()
        make()
    }

    private var letterComponents: [[LetterEntity]] = {
        var result = [[LetterEntity]]()
        for i in 1...6 {
            var line = [LetterEntity]()
            for j in 1...5 {
                let entity = LetterEntity()
                entity.color = .lightGray
                line.append(entity)
            }
            result.append(line)
        }

        return result
    }()

    private let keyboardKeys = ["qwertyuiop", "asdfghjkl", "⌫zxcvbnm↩"]

    private lazy var keyboardComponents: [[LetterEntity]] = {
        var result = [[LetterEntity]]()
        for keysLine in keyboardKeys {
            var line = [LetterEntity]()
            for key in keysLine {
                let entity = LetterEntity()
                entity.color = Colors.lightGray
                entity.letter = key.uppercased()
                line.append(entity)
                let hoverEffectComponent = HoverEffectComponent()
                var collision = CollisionComponent(shapes: [.generateBox(size: .init(x: 0.05, y: 0.05, z: 0.05))])
                collision.filter = CollisionFilter(group: [], mask: [])
                entity.components.set(hoverEffectComponent)
                entity.components.set(collision)
                entity.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
            }
            result.append(line)
        }

        return result
    }()

    private func make() {
        for (i, line) in letterComponents.enumerated() {
            for (j, component) in line.enumerated() {
                component.transform = .init(
                    translation: .init(
                        x: -0.25 + 0.1 * Float(j),
                        y: 0.4 - 0.1 * Float(i),
                        z: 0
                    )
                )
                addChild(component)
            }
        }

        for (i, line) in keyboardComponents.enumerated() {
            for (j, component) in line.enumerated() {
                let step = Float(1) / Float(line.count)
                component.transform = .init(
                    translation: .init(
                        x: -0.5 + step * Float(j),
                        y: -0.3 - 0.1 * Float(i),
                        z: 0
                    )
                )
                addChild(component)
            }
        }
    }

    func updateText(_ text: String) {
        if currentLine > 0 {
            let correctLetterSet = Set(word)
            for i in 0..<currentLine {
                for (j, letterComponent) in letterComponents[i].enumerated() {
                    let letter = letterComponent.letter
                    let color: UIColor

                    if letter == String(word[word.index(word.startIndex, offsetBy: j)]) {
                        color = Colors.green
                    } else if correctLetterSet.contains(letter) {
                        color = Colors.yellow
                    } else {
                        color = Colors.gray
                    }

                    letterComponent.color = color
                }
            }
        }

        for (index, char) in text.prefix(5).padding(toLength: 5, withPad: " ", startingAt: 0).enumerated() {
            letterComponents[currentLine][index].letter = String(char)
        }
    }

    func trySubmit() {
        guard currentLine < 6 else { return }
        let currentString = letterComponents[currentLine].map(\.letter).joined()
        guard currentString.count == 5 else { return }
        currentLine += 1
    }
}

