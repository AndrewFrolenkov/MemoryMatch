//
//  Helper.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 19.05.25.
//

import Foundation
import SpriteKit

func pxToPoints(_ px: CGFloat) -> CGFloat {
    return px / UIScreen.main.scale
}

func calculatefont(_ size: CGFloat) -> CGFloat {
    size / UIScreen.main.scale
}
