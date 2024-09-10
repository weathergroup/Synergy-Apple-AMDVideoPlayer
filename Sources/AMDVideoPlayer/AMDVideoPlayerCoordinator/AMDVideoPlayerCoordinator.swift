//
//  File.swift
//  
//
//

import SwiftUI
import AVKit
import Combine

/// The AMDVideoPlayerCoordinator acts as a delegate object for the
/// AVPlayerViewController object used by the AMDVideoPlayer.
///
/// This coordinator functions as a receptionist, implementing all delegate
/// methods of the AVPlayerViewControllerDelegate protocol and forwarding the
/// calls it receives to objects specifically designed to manage an aspect of
/// playback. These specialized objects are provided to the coordinator by a
/// playback manager that it receives during its construction from an
/// AMDVideoPlayer instance. Typically, the playback manager is received by the
/// player instance during its construction, and is forwarded to the the
/// coordinator.
///
/// The framework provides eight types of specialized coordinator protocols that
/// align with the features available to the AVPlayerViewControllerDelegate
/// protocol. These include:
/// - Channel navigation via the AMDChannelNavigationCoordinator protocol
/// - Content proposal coordination via the AMDContentProposalCoordination protocol
/// - Interstitial coordination via the AMDInterstitialCoordination protocol
/// - Media selection coordination via the AMDMediaSelectionCoordination protocol
/// - Picture-in-Picture presentation coordination via the AMDPIPCoordination protocol
/// - In-app presentation coordination via the AMDVideoPresentationCoordinator protocol
/// - User interface setup and behavior coordination via the AMDUserInterfaceCoordinator protocol
/// - Video navigation via the AMDVideoNavigationCoordinator protocol
///
/// The use of the suffix Coordinator for each protocol is intentional as they
/// define a set of methods used to coodinate the behavior of the video player
/// and the options available to the user to customize that playback.
///
/// Note that all references to the specialized coordinator objects are unowned.
///
@Observable
public class AMDVideoPlayerCoordinator: NSObject, AVPlayerViewControllerDelegate {
    
    unowned let channelNavigationCoordinator: AMDChannelNavigationCoordinator?
    unowned let contentProposalCoordinator: AMDContentProposalCoordinator?
    unowned let interstitialCoordinator: AMDInterstitialCoordinator?
    unowned let mediaSelectionCoordinator: AMDMediaSelectionCoordinator?
    unowned let pictureInPictureCoordinator: AMDPictureInPictureCoordinator?
    unowned let userInterfaceCoordinator: AMDUserInterfaceCoordinator?
    unowned let videoNavigationCoordinator: AMDVideoNavigationCoordinator?
    unowned let videoPresentationCoordinator: AMDVideoPresentationCoordinator?
    
    unowned var playerController: AVPlayerViewController?
    
    init(playbackManager: AMDPlaybackManager) {
        self.channelNavigationCoordinator = playbackManager as? AMDChannelNavigationCoordinator
        self.contentProposalCoordinator = playbackManager as? AMDContentProposalCoordinator
        self.interstitialCoordinator = playbackManager as? AMDInterstitialCoordinator
        self.mediaSelectionCoordinator = playbackManager as? AMDMediaSelectionCoordinator
        self.pictureInPictureCoordinator = playbackManager as? AMDPictureInPictureCoordinator
        self.userInterfaceCoordinator = playbackManager as? AMDUserInterfaceCoordinator
        self.videoNavigationCoordinator = playbackManager as? AMDVideoNavigationCoordinator
        self.videoPresentationCoordinator = playbackManager as? AMDVideoPresentationCoordinator
    }
    
    
}


