//
//  GameScene.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 16.05.25.
//

import SpriteKit

class GameScene: SKScene {
    
    var cards: [CardModel] = []
    var firstFlippedCardIndex: Int? = nil
    
    private let viewModel = GameViewModel()
    
    var infoBackground: InfoBackgroundNode!
    var settingsButton: SKButton!
    
    override func didMove(to view: SKView) {
        
        setupUI()
        setupBindings()
        viewModel.startTimer()
        setupCards()
        
        
    }
    
    private func setupUI() {

        let background = SKSpriteNode(imageNamed: "background")
        background.position = .zero
        background.size = size
        background.zPosition = 0
        addChild(background)
        
        let buttonSize = CGSize(width: pxToPoints(121), height: pxToPoints(121))
        settingsButton = SKButton(imageNamed: "Settings", size: buttonSize) {
            print("Кнопка нажата")
        }
        settingsButton.position = CGPoint(
            x: -size.width / 2 + pxToPoints(60) + buttonSize.width / 2,
            y: size.height / 2 - pxToPoints(181) - buttonSize.height / 2
        )
        addChild(settingsButton)
        
        let infoSize = CGSize(width: size.width - pxToPoints(50), height: 50)
        infoBackground = InfoBackgroundNode(size: infoSize)
        infoBackground.position = CGPoint(
            x: 0,
            y: size.height / 2 - pxToPoints(360) - buttonSize.height / 2
        )
        addChild(infoBackground)
    }
    
    
    private func setupBindings() {
        viewModel.onTimeUpdate = { [weak self] timeString in
            self?.infoBackground.updateTime(timeString)
        }
        
        viewModel.onMovesUpdate = { [weak self] moves in
            self?.infoBackground.updateMoves(moves)
        }
    }
    
    
    func setupCards() {
        let cardDataArray = viewModel.generateCardData()
        
        let cardSize = CGSize(width: pxToPoints(220), height: pxToPoints(220))
        let padding: CGFloat = 25
        let infoBackgroundY = size.height / 2 - pxToPoints(360) - pxToPoints(121) / 2
        let startY = infoBackgroundY - 100
        let startX = -((cardSize.width + padding) * 1.5)
        
        for row in 0..<4 {
            for col in 0..<4 {
                let index = row * 4 + col
                let cardData = cardDataArray[index]
                
                let backTexture = SKTexture(imageNamed: "cardBack")
                let sprite = SKSpriteNode(texture: backTexture, size: cardSize)
                sprite.position = CGPoint(
                    x: startX + CGFloat(col) * (cardSize.width + padding),
                    y: startY - CGFloat(row) * (cardSize.height + padding)
                )
                sprite.name = "\(index)"
                
                let card = CardModel(id: cardData.id, imageName: cardData.imageName, node: sprite)
                cards.append(card)
                addChild(sprite)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let node = nodes(at: location).first as? SKSpriteNode,
              let index = Int(node.name ?? ""),
              !cards[index].isFlipped,
              !cards[index].isMatched else { return }
        
        flipCardOpen(at: index)
        
        if firstFlippedCardIndex == nil {
            firstFlippedCardIndex = index
        } else {
            viewModel.incrementMoves()
            let firstIndex = firstFlippedCardIndex!
            let secondIndex = index
            
            let firstImage = cards[firstIndex].imageName
            let secondImage = cards[secondIndex].imageName
            
            if firstImage == secondImage {
                // Успешное совпадение
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
                firstFlippedCardIndex = nil
                
                if cards.allSatisfy({ $0.isMatched }) {
                    isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showWin()
                        self.isUserInteractionEnabled = true
                    }
                }
            } else {
                // Несовпадение — закрыть через 1 сек
                isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.flipCardClose(at: firstIndex)
                    self.flipCardClose(at: secondIndex)
                    self.firstFlippedCardIndex = nil
                    self.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func flipCardOpen(at index: Int) {
        let card = cards[index]
        let node = card.node
        
        // Прокрутка: 6 кадров случайных картинок перед финальной
        var textures: [SKAction] = []
        for _ in 0..<6 {
            let randomIndex = Int.random(in: 1...8)
            let tempTexture = SKTexture(imageNamed: "card\(randomIndex)")
            textures.append(SKAction.run { node.texture = tempTexture })
            textures.append(SKAction.wait(forDuration: 0.05))
        }
        
        // Финальная картинка
        let finalTexture = SKAction.run {
            node.texture = SKTexture(imageNamed: card.imageName)
        }
        
        // Добавим небольшое движение вниз и вверх для эффекта
        let moveDown = SKAction.moveBy(x: 0, y: -5, duration: 0.05)
        let moveUp = SKAction.moveBy(x: 0, y: 5, duration: 0.05)
        let move = SKAction.sequence([moveDown, moveUp])
        
        let fullEffect = SKAction.sequence(textures + [finalTexture, move])
        node.run(fullEffect)
        
        cards[index].isFlipped = true
    }
    
    func flipCardClose(at index: Int) {
        let node = cards[index].node
        
        let flipHalf = SKAction.scaleX(to: 0, duration: 0.2)
        let changeTexture = SKAction.run {
            node.texture = SKTexture(imageNamed: "cardBack")
        }
        let flipBack = SKAction.scaleX(to: 1, duration: 0.2)
        let sequence = SKAction.sequence([flipHalf, changeTexture, flipBack])
        
        node.run(sequence)
        cards[index].isFlipped = false
    }
    
    func showWin() {
        
        viewModel.stopTimer()
        
        let overlay = WinOverlayNode(size: size, moves: viewModel.moves, timeElapsed: infoBackground.timeLabel.text ?? "00:00")
        addChild(overlay)
    }
}
