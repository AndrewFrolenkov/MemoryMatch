//
//  WinOverlayNode.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import SpriteKit

class WinOverlayNode: SKNode {
    
    var restartButton: SKButton!
    var menuButton: SKButton!
    
    var onRestartButtonTapped: (() -> Void)?
    var backToMenuButtonTapped: (() -> Void)?
    
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
        winBoard.position = CGPoint(x: 0, y: -size.height / 2 + pxToPoints(738) + winBoard.size.height / 2)
        winBoard.zPosition = 102
        addChild(winBoard)
        
        let youWin = SKSpriteNode(imageNamed: "youWin")
        youWin.size = CGSize(width: size.width - pxToPoints(30), height: pxToPoints(1000))
        youWin.position = CGPoint(x: 0, y: -size.height / 2 + pxToPoints(900) + youWin.size.height / 2)
        youWin.zPosition = 103
        addChild(youWin)
        
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
        
        let buttonSize = CGSize(width: pxToPoints(121), height: pxToPoints(121))
        restartButton = SKButton(imageNamed: "Undo", size: buttonSize) { [weak self] in
            self?.onRestartButtonTapped?() 
        }
        restartButton.position = CGPoint(
            x: -20 - buttonSize.height / 2,
            y: -size.height / 2 + pxToPoints(576) + buttonSize.height / 2
        )
        restartButton.zPosition = 103
        addChild(restartButton)
        
        menuButton = SKButton(imageNamed: "goToMenu", size: buttonSize) { [weak self] in
            self?.onRestartButtonTapped?()
        }
        menuButton.position = CGPoint(
            x: 20 + buttonSize.height / 2,
            y: -size.height / 2 + pxToPoints(576) + buttonSize.height / 2
        )
        menuButton.zPosition = 103
        addChild(menuButton)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
