import SpriteKit

class LoadingScene: SKScene {
    
    private var fireSprite: SKSpriteNode!
    private var loadingLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        setupUI()
        startFireAnimation()
        simulateLoading()
    }
}

extension LoadingScene {
    private func setupUI() {
        let background = SKSpriteNode(imageNamed: "loadingBG")
        background.size = size
        background.zPosition = 0
        addChild(background)
        
        fireSprite = SKSpriteNode(imageNamed: "Fire")
        fireSprite.size = CGSize(width: 300, height: 300)
        fireSprite.position = CGPoint(x: 0, y: size.height / 2)
        fireSprite.zPosition = 1
        addChild(fireSprite)
        
        loadingLabel = SKLabelNode(text: "Loading...")
        loadingLabel.fontName = "Helvetica-Bold"
        loadingLabel.fontSize = 36
        loadingLabel.fontColor = .white
        loadingLabel.zPosition = 1
        addChild(loadingLabel)
    }
    
    private func startFireAnimation() {
        let topY = size.height / 2
        let centerY = 0.0
        let moveDown = SKAction.moveTo(y: centerY, duration: 2.0)
        let moveUp = SKAction.moveTo(y: topY, duration: 2.0)
        let sequence = SKAction.sequence([moveDown, moveUp])
        let repeatForever = SKAction.repeatForever(sequence)
        fireSprite.run(repeatForever)
    }
    
    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.loadingFinished()
        }
    }
    
    private func loadingFinished() {
        fireSprite.removeAllActions()
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        fireSprite.run(fadeOut)
        loadingLabel.run(fadeOut)
        
        if let view = self.view {
            let mainScene = MainScene(size: view.bounds.size)
            mainScene.scaleMode = .resizeFill
            mainScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(mainScene, transition: SKTransition.fade(withDuration: 1))
        }
    }
}
