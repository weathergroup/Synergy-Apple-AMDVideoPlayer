//
//  AMDInterstitialCoordinator.swift
//  
//
//

import SwiftUI
import AVKit
import Combine


/*
 Extension for interstitial events
 */
extension AMDVideoPlayerCoordinator {
    public func playerViewController(_ playerViewController: AVPlayerViewController,
                              willPresent interstitial: AVInterstitialTimeRange) {
        
        NotificationCenter.default.post(name: AMDVideoPlayer.InterstitialBegan,
                                        object: playerViewController.player?.currentItem)
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, 
                              didPresent interstitial: AVInterstitialTimeRange) {
        
        NotificationCenter.default.post(name: AMDVideoPlayer.InterstitialEnded,
                                        object: playerViewController.player?.currentItem)
    }
    
}

public protocol AMDInterstitialCoordinator: AnyObject {
    
    func interstitialEvents(for playerItems: [AVPlayerItem]) -> [AVPlayerInterstitialEvent]
}
