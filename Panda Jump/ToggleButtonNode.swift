//
//  ToggleButtonNode.swift
//  Panda Jump
//

import SpriteKit

/// An on/off icon button. The node itself is an invisible square at least
/// `minimumTouchSize` across, with the artwork as a child at its natural size, so
/// small icons still get a comfortable tap target.
class ToggleButtonNode: SKSpriteNode {

    static let minimumTouchSize: CGFloat = 44

    private let onTexture: SKTexture
    private let offTexture: SKTexture
    private let icon: SKSpriteNode

    var onToggle: ((Bool) -> Void)?

    var isOn: Bool {
        didSet { icon.texture = isOn ? onTexture : offTexture }
    }

    init(onTexture: SKTexture, offTexture: SKTexture, isOn: Bool) {
        self.onTexture = onTexture
        self.offTexture = offTexture
        self.isOn = isOn
        icon = SKSpriteNode(texture: isOn ? onTexture : offTexture)

        let side = max(icon.size.width, icon.size.height, ToggleButtonNode.minimumTouchSize)
        super.init(texture: nil, color: .clear, size: CGSize(width: side, height: side))

        addChild(icon)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPressed(_ pressed: Bool) {
        icon.alpha = pressed ? 0.5 : 1.0
    }

    func toggle() {
        isOn.toggle()
        onToggle?(isOn)
    }
}
