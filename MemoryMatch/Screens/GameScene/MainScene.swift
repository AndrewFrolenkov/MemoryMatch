//
//  MainScene.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 20.05.25.
//

import SafariServices
import Foundation
import SpriteKit

class MainScene: SKScene {
    
    var startGameButton: SKButton!
    var privacyPolicyButton: SKButton!
    
    override func didMove(to view: SKView) {
       setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension MainScene {
    private func setupUI() {
        
        let background = SKSpriteNode(imageNamed: "Menu")
        background.position = .zero
        background.size = size
        background.zPosition = 0
        addChild(background)
        
        let playButtonWidth = min(pxToPoints(628), size.width * 0.8)
        let playButtonHeight = pxToPoints(154)
        
        startGameButton = SKButton(
            imageNamed: "PlayButton",
            size: CGSize(width: playButtonWidth, height: playButtonHeight),
            text: "PLAY NOW",
            action: { [weak self] in self?.playGame() }
        )
        
        let privacyButtonWidth = min(pxToPoints(456), size.width * 0.6)
        let privacyButtonHeight = pxToPoints(88)
        
        privacyPolicyButton = SKButton(
            imageNamed: "PlayButton",
            size: CGSize(width: privacyButtonWidth, height: privacyButtonHeight),
            text: "PRIVACY POLICY",
            fontSize: calculatefont(32),
            action: { [weak self] in self?.openURLInSafariViewController("https://www.apple.com/privacy/") }
        )
        
        let bottomPadding: CGFloat = size.height * 0.1  // 10% от высоты экрана
        
        // privacyPolicyButton — ниже, рядом с нижним краем
        privacyPolicyButton.position = CGPoint(
            x: 0,
            y: -size.height / 2 + bottomPadding + privacyButtonHeight / 2
        )
        addChild(privacyPolicyButton)
        
        // startGameButton — выше privacyPolicyButton с отступом
        startGameButton.position = CGPoint(
            x: 0,
            y: privacyPolicyButton.position.y + privacyButtonHeight / 2 + 20 + playButtonHeight / 2
        )
        addChild(startGameButton)
    }


}

extension MainScene {
    func playGame() {
        if let view = self.view {
            let blurTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.8)
            let newScene = GameScene(size: view.bounds.size)
            newScene.scaleMode = .resizeFill
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(newScene, transition: blurTransition)
        }
    }
}
