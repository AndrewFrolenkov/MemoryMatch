//
//  GameViewController.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 16.05.25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        }
    }
}
