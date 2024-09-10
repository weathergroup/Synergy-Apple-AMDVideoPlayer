//
//  AMDVideoNavigationCoordinator.swift
//
//
//

import SwiftUI
import AVKit
import Combine

/*
 Extension for navigation events
 */
extension AMDVideoPlayerCoordinator {
    public func playerViewController(_ playerViewController: AVPlayerViewController,
                              timeToSeekAfterUserNavigatedFrom oldTime: CMTime,
                              to targetTime: CMTime) -> CMTime {
        return targetTime
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController,
                              willResumePlaybackAfterUserNavigatedFrom oldTime: CMTime,
                              to targetTime: CMTime) {
        
    }
    
    public func skipToNextItem(for playerViewController: AVPlayerViewController) {
        
    }
    
    public func skipToPreviousItem(for playerViewController: AVPlayerViewController) {
        
    }
}

public protocol AMDVideoNavigationCoordinator: AnyObject {
    
}
