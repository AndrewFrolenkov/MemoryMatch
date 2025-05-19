//
//  SKButton.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import SpriteKit

class SKButton: SKSpriteNode {
    
    private var action: (() -> Void)?

    init(imageNamed: String, size: CGSize, action: @escaping () -> Void) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: size)
        self.action = action
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 0.7 // легкий эффект нажатия
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        guard let touch = touches.first, let parent = self.parent else { return }
        let location = touch.location(in: parent)
        if self.contains(location) {
            action?()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
    }
}

