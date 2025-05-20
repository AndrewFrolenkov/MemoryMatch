//
//  GameScene.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 16.05.25.
//

import SpriteKit
import AudioToolbox

class GameScene: SKScene {
    
    private let viewModel = GameViewModel()
    
    var infoBackground: InfoBackgroundNode!
    var settingsButton: SKButton!
    var pauseButton: SKButton!
    var backButton: SKButton!
    var restartButton: SKButton!
    
    var isGamePaused = false
    var isVibrationEnabled = true
    var isSoundEnabled = true
    
    override func didMove(to view: SKView) {
        
        setupUI()
        setupBindings()
        viewModel.startNewGame()
        setupCards()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGamePaused else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let node = nodes(at: location).first as? SKSpriteNode,
              let index = Int(node.name ?? "") else { return }
        
        viewModel.handleCardTap(at: index)
    }
    
    func showWin() {
        
        viewModel.stopTimer()
        
        let overlay = WinOverlayNode(size: size, moves: viewModel.moves, timeElapsed: infoBackground.timeLabel.text ?? "00:00")
        addChild(overlay)
        
        overlay.onRestartButtonTapped = { [weak self] in
            self?.restartGame()
        }
        
        overlay.backToMenuButtonTapped = { [weak self] in
            self?.backToMenu()
        }
    }
    
    func showSettings() {
        
        let settings = SettingsNote(size: size, isSoundEnabled: isSoundEnabled, isVibrationEnabled: isVibrationEnabled)
        addChild(settings)
        
        settings.onVolumeButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.isSoundEnabled.toggle()
        }
        
        settings.onVibroButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.isVibrationEnabled.toggle()
        }
        
        settings.continueGameButtonTapped = { [weak self] in
            self?.togglePause()
        }
        
        togglePause()
    }
    
    deinit {
        
        print("GameScene DEINIT — сцена удалена из памяти ✅")
    }
}

extension GameScene {
    
    private func setupUI() {
        // Фон
        let background = SKSpriteNode(imageNamed: "background")
        background.position = .zero
        background.size = size
        background.zPosition = 0
        addChild(background)

        // 🔧 Относительные коэффициенты — адаптивные!
        let buttonSide = size.width * 0.15  // 15% ширины экрана — универсально
        let buttonSize = CGSize(width: buttonSide, height: buttonSide)

        let horizontalInset = size.width * 0.06
        let topInset = size.height * 0.08
        let bottomInset = size.height * 0.09
        let infoOffset = size.height * 0.18

        // Settings (верхний левый угол)
        settingsButton = SKButton(imageNamed: "Settings", size: buttonSize) { [weak self] in
            self?.showSettings()
        }
        settingsButton.position = CGPoint(
            x: -size.width / 2 + horizontalInset + buttonSide / 2,
            y: size.height / 2 - topInset - buttonSide / 2
        )
        addChild(settingsButton)

        // Pause (нижний левый)
        pauseButton = SKButton(imageNamed: "Pause", size: buttonSize) { [weak self] in
            print("Кнопка нажата")
            self?.togglePause()
        }
        pauseButton.position = CGPoint(
            x: -size.width / 2 + horizontalInset + buttonSide / 2,
            y: -size.height / 2 + bottomInset + buttonSide / 2
        )
        addChild(pauseButton)

        // Back (центр снизу)
        backButton = SKButton(imageNamed: "Left", size: buttonSize) { [weak self] in
            self?.backToMenu()
        }
        backButton.position = CGPoint(
            x: 0,
            y: -size.height / 2 + bottomInset + buttonSide / 2
        )
        addChild(backButton)

        // Restart (правый нижний угол)
        restartButton = SKButton(imageNamed: "Undo", size: buttonSize) { [weak self] in
            self?.restartGame()
        }
        restartButton.position = CGPoint(
            x: size.width / 2 - horizontalInset - buttonSide / 2,
            y: -size.height / 2 + bottomInset + buttonSide / 2
        )
        addChild(restartButton)

        // Инфопанель — над кнопкой settings
        let infoHeight = size.height * 0.06
        let infoWidth = size.width * 0.88
        infoBackground = InfoBackgroundNode(size: CGSize(width: infoWidth, height: infoHeight))
        infoBackground.position = CGPoint(
            x: 0,
            y: size.height / 2 - topInset - buttonSide - infoHeight / 2 - infoOffset * 0.1
        )
        addChild(infoBackground)
    }

    
    func setupCards() {
        let cardDataArray = viewModel.generateCardData()

        let cardRows = 4
        let cardColumns = 4

        let cardWidth = size.width * 0.17
        let cardSize = CGSize(width: cardWidth, height: cardWidth)
        let padding = size.width * 0.035

        let infoBackgroundBottomY = size.height / 2 - pxToPoints(360) - pxToPoints(121) / 2

        let gridHeight = CGFloat(cardRows) * cardSize.height + CGFloat(cardRows - 1) * padding
        let minY = -size.height / 2
        let availableHeight = infoBackgroundBottomY - minY

        // Поднимаем сетку вверх на 70 пунктов
        let startY = infoBackgroundBottomY - (availableHeight - gridHeight) / 2 + 70

        let totalWidth = CGFloat(cardColumns) * cardSize.width + CGFloat(cardColumns - 1) * padding
        let startX = -totalWidth / 2 + cardSize.width / 2

        for row in 0..<cardRows {
            for col in 0..<cardColumns {
                let index = row * cardColumns + col
                let cardData = cardDataArray[index]

                let backTexture = SKTexture(imageNamed: "cardBack")
                let sprite = SKSpriteNode(texture: backTexture, size: cardSize)
                sprite.position = CGPoint(
                    x: startX + CGFloat(col) * (cardSize.width + padding),
                    y: startY - CGFloat(row) * (cardSize.height + padding)
                )
                sprite.name = "\(index)"

                let card = CardModel(id: cardData.id, imageName: cardData.imageName, node: sprite)
                viewModel.cards.append(card)
                addChild(sprite)
            }
        }
    }

}

extension GameScene {
    private func setupBindings() {
        viewModel.onTimeUpdate = { [weak self] timeString in
            self?.infoBackground.updateTime(timeString)
        }
        
        viewModel.onMovesUpdate = { [weak self] moves in
            self?.infoBackground.updateMoves(moves)
        }
        
        viewModel.onFlipCard = { [weak self] index in
            self?.flipCardOpen(at: index)
        }
        
        //        viewModel.onMatch = { [weak self] _, _ in
        //
        //        }
        
        viewModel.onMismatch = { [weak self] first, second in
            guard let self = self else { return }
            if self.isVibrationEnabled {
#if os(iOS)
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
#endif
            }
            
            if self.isSoundEnabled {
                    self.playErrorSound()
                }
            
            self.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.flipCardClose(at: first)
                self.flipCardClose(at: second)
                self.isUserInteractionEnabled = true
            }
        }
        
        viewModel.onGameCompleted = { [weak self] in
            self?.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.showWin()
                self?.isUserInteractionEnabled = true
            }
        }
    }
}

extension GameScene {
    private func flipCardOpen(at index: Int) {
        let card = viewModel.cards[index]
        let node = card.node
        
        var textures: [SKAction] = []
        for _ in 0..<6 {
            let randomIndex = Int.random(in: 1...8)
            let tempTexture = SKTexture(imageNamed: "card\(randomIndex)")
            textures.append(SKAction.run { node.texture = tempTexture })
            textures.append(SKAction.wait(forDuration: 0.05))
        }
        
        let finalTexture = SKAction.run {
            node.texture = SKTexture(imageNamed: card.imageName)
        }
        
        let moveDown = SKAction.moveBy(x: 0, y: -5, duration: 0.05)
        let moveUp = SKAction.moveBy(x: 0, y: 5, duration: 0.05)
        let move = SKAction.sequence([moveDown, moveUp])
        
        let fullEffect = SKAction.sequence(textures + [finalTexture, move])
        node.run(fullEffect)
        
        viewModel.cards[index].isFlipped = true
    }
    
    private func flipCardClose(at index: Int) {
        let node = viewModel.cards[index].node
        
        let flipHalf = SKAction.scaleX(to: 0, duration: 0.2)
        let changeTexture = SKAction.run {
            node.texture = SKTexture(imageNamed: "cardBack")
        }
        let flipBack = SKAction.scaleX(to: 1, duration: 0.2)
        let sequence = SKAction.sequence([flipHalf, changeTexture, flipBack])
        
        node.run(sequence)
        viewModel.cards[index].isFlipped = false
    }
}

extension GameScene {
    func togglePause() {
        isGamePaused.toggle()
        self.isPaused = isGamePaused
        viewModel.setPause(isGamePaused)
        
        let newTextureName = isGamePaused ? "Play" : "Pause"
        pauseButton.texture = SKTexture(imageNamed: newTextureName)
    }
    
    func restartGame() {
        if let view = self.view {
            let newScene = GameScene(size: view.bounds.size)
            newScene.scaleMode = .resizeFill
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
    
    func backToMenu() {
        if let view = self.view {
            let newScene = MainScene(size: view.bounds.size)
            newScene.scaleMode = .resizeFill
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(newScene, transition: SKTransition.push(with: .right, duration: 0.5))
        }
    }
    
    func playErrorSound() {
    #if os(iOS)
        AudioServicesPlaySystemSound(SystemSoundID(1053))
    #endif
    }
}
