//
//  InfoBackgroundNode.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import SpriteKit

class InfoBackgroundNode: SKSpriteNode {
    
    private(set) var stepsLabel: SKLabelNode!
    private(set) var timeLabel: SKLabelNode!
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "backgroundMoveAndTime"), color: .clear, size: size)
        self.zPosition = 10
        setupLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabels()
    }
    
    private func setupLabels() {
        stepsLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        stepsLabel.fontSize = 52 / UIScreen.main.scale
        stepsLabel.fontColor = .white
        stepsLabel.horizontalAlignmentMode = .left
        stepsLabel.verticalAlignmentMode = .center
        stepsLabel.text = "MOVIES: 0"
        stepsLabel.position = CGPoint(x: -size.width / 2 + 20, y: 0)
        addChild(stepsLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        timeLabel.fontSize = 52 / UIScreen.main.scale
        timeLabel.fontColor = .white
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.verticalAlignmentMode = .center
        timeLabel.text = "TIME: 00:00"
        timeLabel.position = CGPoint(x: size.width / 2 - 20, y: 0)
        addChild(timeLabel)
    }
    
    func updateMoves(_ moves: Int) {
        stepsLabel.text = "MOVIES: \(moves)"
    }
    
    func updateTime(_ timeString: String) {
        timeLabel.text = "TIME: \(timeString)"
    }
}
