//
//  WinOverlayNode.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import SpriteKit

class WinOverlayNode: SKNode {
    
    init(size: CGSize, moves: Int, timeElapsed: String) {
        super.init()
        
        // Полупрозрачный фон
        let dimBackground = SKSpriteNode(color: .black, size: size)
        dimBackground.alpha = 0.6
        dimBackground.position = CGPoint(x: 0, y: 0)
        dimBackground.zPosition = 100
        addChild(dimBackground)
        
        // Окно победы
        let winBackground = SKSpriteNode(imageNamed: "BG_3 Parallax")
        winBackground.size = CGSize(width: size.width, height: size.height)
        winBackground.position = CGPoint(x: 0, y: 0)
        winBackground.zPosition = 101
        addChild(winBackground)
        
        let winBoard = SKSpriteNode(imageNamed: "board")
        winBoard.size = CGSize(width: size.width - pxToPoints(101), height: pxToPoints(462))
        winBoard.position = CGPoint(x: 0, y: 0)
        winBoard.zPosition = 102
        addChild(winBoard)
        
        // Количество ходов
        let movesLabel = SKLabelNode(text: "MOVIES: \(moves)")
        movesLabel.fontName = "Helvetica"
        movesLabel.fontSize = calculatefont(51)
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: 0, y: 0)
        movesLabel.zPosition = 102
        winBoard.addChild(movesLabel)
        
        // Время
        let timeLabel = SKLabelNode(text: "TIME: \(timeElapsed)")
        timeLabel.fontName = "Helvetica"
        timeLabel.fontSize = calculatefont(51)
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: 0, y: -40)
        timeLabel.zPosition = 102
        winBoard.addChild(timeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
