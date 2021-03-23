//
//  PlayerView.swift
//  Meetflix
//
//  Created by leejungchul on 2021/03/22.
//

import Foundation
import AVKit

// https://developer.apple.com/documentation/avfoundation/avplayerlayer
class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
