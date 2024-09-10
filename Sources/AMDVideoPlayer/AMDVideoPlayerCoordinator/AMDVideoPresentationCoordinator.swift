//
//  AMDVideoPresentationCoordinator.swift
//
//
//

import SwiftUI
import AVKit
import Combine



/*
 Extension for tvOS presentation coordination
 */
#if os(tvOS)
extension AMDVideoPlayerCoordinator {
    public func playerViewControllerShouldDismiss(_ playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
    
    public func playerViewControllerWillBeginDismissalTransition(_ playerViewController: AVPlayerViewController) {
        
    }
    
    public func playerViewControllerDidEndDismissalTransition(_ playerViewController: AVPlayerViewController) {
        
    }
    
}
#endif

/*
 Extension for iOS, iPadOS, and visionOS presentation coordination
 */
#if os(iOS)
extension AMDVideoPlayerCoordinator {
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator) {
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator) {
        
    }
    
    func playerViewControllerRestoreUserInterfaceForFullScreenExit(_ playerViewController: AVPlayerViewController) async -> Bool {
        return true
    }
}
#endif

public protocol AMDVideoPresentationCoordinator: AnyObject {
    
}
