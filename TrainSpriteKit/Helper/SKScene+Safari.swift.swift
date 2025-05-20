//
//  SKScene+Safari.swift.swift
//  TrainSpriteKit
//
//  Created by Андрей Фроленков on 20.05.25.
//

import SpriteKit
import SafariServices
import UIKit

extension SKScene {
    func openURLInSafariViewController(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard let viewController = self.view?.window?.rootViewController else { return }
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
}
