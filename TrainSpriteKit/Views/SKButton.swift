//
//  SKButton.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import SpriteKit

class SKButton: SKSpriteNode {
    
    private var action: (() -> Void)?
    private var labelNode: SKLabelNode?

    init(imageNamed: String, size: CGSize, action: @escaping () -> Void) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: size)
        self.action = action
        isUserInteractionEnabled = true
    }
    
    convenience init(imageNamed: String,
                        size: CGSize,
                        text: String? = nil,
                        fontName: String = "Helvetica",
                        fontSize: CGFloat = 20,
                        fontColor: SKColor = .white,
                        action: @escaping () -> Void) {
        self.init(imageNamed: imageNamed, size: size, action: action)
           
           self.action = action
           isUserInteractionEnabled = true
           
           if let text = text {
               let label = SKLabelNode(text: text)
               label.fontName = fontName
               label.fontSize = fontSize
               label.fontColor = fontColor
               label.verticalAlignmentMode = .center
               label.horizontalAlignmentMode = .center
               label.position = CGPoint(x: 0, y: 0)
               label.zPosition = 1
               addChild(label)
               labelNode = label
           }
       }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 0.7
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

