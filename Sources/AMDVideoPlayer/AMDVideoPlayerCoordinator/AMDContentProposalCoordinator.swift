//
//  AMDContentProposalCoordinator.swift
//  
//
//

import SwiftUI
import AVKit
import Combine


/*
 This extension defines the delegate methods used by the AVPlayerViewController
 object of an AMDVideoPlayer instance for content proposals. As of iOS 16, this
 is only supported on tvOS and is excluded from compilation in iOS builds.
 
 See the documentation for the AMDChannelContentProposalCoordinator for
 additional details.
 */
#if os(tvOS)
extension AMDVideoPlayerCoordinator {
    public func playerViewController(_ playerViewController: AVPlayerViewController,
                              didAccept proposal: AVContentProposal) {
        guard let coordinator = contentProposalCoordinator
        else { return }
        
        coordinator.videoPlayerAccepted(contentProposal: proposal)
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController,
                              didReject proposal: AVContentProposal) {
        guard let coordinator = contentProposalCoordinator
        else { return }
        
        coordinator.videoPlayerRejected(contentProposal: proposal)
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, 
                              shouldPresent proposal: AVContentProposal) -> Bool {
        
        guard let coordinator = contentProposalCoordinator
        else { return true }
        
        return coordinator.videoPlayerShouldPresent(contentProposal: proposal)
        
    }

}
#endif

public protocol AMDContentProposalCoordinator: AnyObject {
    
    func videoPlayerAccepted(contentProposal: AVContentProposal)
    
    func videoPlayerRejected(contentProposal: AVContentProposal)
    
    func videoPlayerShouldPresent(contentProposal: AVContentProposal) -> Bool
    
}
