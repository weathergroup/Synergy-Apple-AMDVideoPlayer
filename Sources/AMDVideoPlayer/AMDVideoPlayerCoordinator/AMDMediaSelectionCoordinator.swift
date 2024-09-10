//
//  AMDMediaSelectionCoordinator.swift
//  
//
//  Created by Erik Heath Thomas on 8/20/24.
//

import SwiftUI
import AVKit
import Combine

//TODO: Notifications?
extension AMDVideoPlayerCoordinator {
    public func playerViewController(_ playerViewController: AVPlayerViewController, 
                              didSelect mediaSelectionOption: AVMediaSelectionOption?,
                              in mediaSelectionGroup: AVMediaSelectionGroup) {
        
        guard let coordinator = mediaSelectionCoordinator
        else { return }
        
        coordinator.videoPlayerSelected(mediaSelectionOption,
                                        in: mediaSelectionGroup)
    }
}

public protocol AMDMediaSelectionCoordinator: AnyObject {
    
    func videoPlayerSelected(_ option: AVMediaSelectionOption?,
                             in group: AVMediaSelectionGroup)
    
}
