//
//  ModelCard.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import Foundation
import SpriteKit

struct CardModel {
    let id: Int
    let imageName: String
    var node: SKSpriteNode
    var isFlipped = false
    var isMatched = false
}
