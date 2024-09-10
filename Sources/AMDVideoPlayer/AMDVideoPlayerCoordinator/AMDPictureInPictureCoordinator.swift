//
//  File.swift
//  
//
//

import SwiftUI
import AVKit
import Combine



/*
 Extension for Picture-in-Picture (PIP) behavior coordination.
 
 See https://developer.apple.com/documentation/avkit/adopting-picture-in-picture-in-a-standard-player
 for a full description of coordinating a PIP transition.
 */
extension AMDVideoPlayerCoordinator {
    
    public func playerViewControllerRestoreUserInterfaceForPictureInPictureStop(_ playerViewController: AVPlayerViewController) async -> Bool {
        return true
    }
    
    public func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
    
    }
    
    public func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    public func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    public func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }

    public func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: any Error) {
        
    }
    
    public func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
    
}

public protocol AMDPictureInPictureCoordinator: AnyObject {
    
}
