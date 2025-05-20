
import SpriteKit

class SettingsNote: SKNode {
    
    var volumeButton: SKButton!
    var vibroButton: SKButton!
    var closeButton: SKButton!
    
    private var isVolumeOn = true
    private var isVibrationOn = true
    
    var onVibroButtonTapped: (() -> Void)?
    var onVolumeButtonTapped: (() -> Void)?
    var continueGameButtonTapped: (() -> Void)?
    
    init(size: CGSize, isSoundEnabled: Bool, isVibrationEnabled: Bool) {
        super.init()
        self.isVolumeOn = isSoundEnabled
        self.isVibrationOn = isVibrationEnabled
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
        
        let buttonSize = CGSize(width: pxToPoints(300), height: pxToPoints(300))
        volumeButton = SKButton(imageNamed: self.isVolumeOn ? "VolumeOn" : "VolumeOff", size: buttonSize) { [weak self] in
            guard let self = self else { return }
            self.isVolumeOn.toggle()
            let newImage = self.isVolumeOn ? "VolumeOn" : "VolumeOff"
            self.volumeButton.texture = SKTexture(imageNamed: newImage)
            self.onVolumeButtonTapped?()
        }
        volumeButton.position = CGPoint(
            x: -20 - buttonSize.height / 2,
            y: 0
        )
        volumeButton.zPosition = 103
        addChild(volumeButton)
        
        vibroButton = SKButton(imageNamed: self.isVibrationOn ? "VibroON" : "NoVibro", size: buttonSize) { [weak self] in
            guard let self = self else { return }
            self.isVibrationOn.toggle()
            let newImage = self.isVibrationOn ? "VibroON" : "NoVibro"
            self.vibroButton.texture = SKTexture(imageNamed: newImage)
            self.onVibroButtonTapped?()
        }
        
        vibroButton.position = CGPoint(
            x: 20 + buttonSize.height / 2,
            y: 0
        )
        vibroButton.zPosition = 103
        addChild(vibroButton)
        
        let closeButtonSize = CGSize(width: pxToPoints(100), height: pxToPoints(100))
        closeButton = SKButton(imageNamed: "Close", size: closeButtonSize) { [weak self] in
            
            self?.closeNode()
            self?.continueGameButtonTapped?()
        }
        closeButton.position = CGPoint(
            x: size.width / 2 - 10 - closeButton.size.width,
            y: size.height / 2 - 50 - closeButton.size.height
        )
        closeButton.zPosition = 103
        addChild(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func closeNode() {
        self.removeFromParent()
    }
}
