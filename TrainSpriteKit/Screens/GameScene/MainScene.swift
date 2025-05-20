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
        
        startGameButton = SKButton(imageNamed: "PlayButton",
                                   size: CGSize(width: pxToPoints(628), height: pxToPoints(154)),
                                   text: "PLAY NOW", action: { [weak self] in
            self?.playGame()
        })
        
        startGameButton.position = CGPoint(
            x: 0,
            y: -size.height / 2 + pxToPoints(883) + startGameButton.size.height / 2
        )
        
        addChild(startGameButton)
        
        privacyPolicyButton = SKButton(imageNamed: "PlayButton",
                                       size: CGSize(width: pxToPoints(456), height: pxToPoints(88)),
                                       text: "PRIVACY POLICY",
                                       fontSize: calculatefont(32),
                                       action: { [weak self] in
            self?.openURLInSafariViewController("https://www.apple.com/privacy/")
        })
        
        privacyPolicyButton.position = CGPoint(
            x: 0,
            y: -size.height / 2 + pxToPoints(550) + startGameButton.size.height / 2
        )
        
        addChild(privacyPolicyButton)
        
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
