//
//  AVPlayer+Ding.swift
//  Scrumdinger
//
//  Created by Atakan Zengin on 01/04/2024.
//

import Foundation
import AVFoundation

extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else {
            fatalError("Failed to find sound file.")
        }
        return AVPlayer(url: url)
    }()
}
