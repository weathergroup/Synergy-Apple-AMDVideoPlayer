// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import AVKit
import Combine


/// The AMDVideoPlayer is a SwiftUI wrapper for the AVKit AVPlayerViewController
/// which is the standard video playback software component across all current
/// video playback capable Apple devices. 
///
/// This player will be replaced in the upcoming OS releases with the SwiftUI
/// VideoPlayer software component. To prepare for the replacement, the
/// AMDVideoPlayer is designed as a drop-in component that isolates playback
/// logic and playback events internally while exposing a public API for
/// presentation event notification and an API for a playback manager that
/// removes custom playback decision logic (what to play, when to play it, what
/// playback features should be presented) from the AMDVideoPlayer.
///
/// The AMDVideoPlayer utilizes multiple supporting objects as follows:
/// - AMDPlaybackManager
/// - AMDVideoPlayerCoordinator
/// - AMD
///
/// How Ads Work
///
/// The video player uses the AVInterstitialPlayer component under-the-hood to
/// ensure consistent, smooth playback of content and ads with configurable
/// restrictions on user interactions during ad playback including seek
/// restrictions, ad countdown, and timeline collapse where appropriate. The
/// interstitial player accepts ad events that specify offset, playback URL,
/// and playback restrictions on a per ad event basis including specifying that
/// a certain number of ads must be played before a seek is completed by the
/// player.
///
/// The Playback Manager
///
/// To insert ads during video playback or to control any other aspect of
/// playback, the video player accepts a playback manager object whose
/// responsibilities include:
/// * Generating ad events and adding them to the player
/// * Providing the correct playback URL to the player
/// * Configuring the UI of the player from available options
/// * Configuring and supporting optional playback behaviors
///
/// For a simple example of how a playback manager works, see the Video Player
/// Reference App which imports this package and creates a manager for HLS VOD
/// and Live Stream playback with ad interstitials place on the VOD stream.
///
public struct AMDVideoPlayer: UIViewControllerRepresentable {
    public typealias UIViewControllerType = AVPlayerViewController
    
    @State private var playbackManager: AMDPlaybackManager
    @State private var coordinator: AMDVideoPlayerCoordinator
    
    /// A playback manager is required for the Video Player to set up its
    /// internal objects, specifically its internal coordinator that acts as a
    /// receptionist for messaging between the playback manager and the internal
    /// AVKit, AVFoundation, and UIKit objects.
    public init(playbackManager: AMDPlaybackManager) {
        self.playbackManager = playbackManager
        self.coordinator = AMDVideoPlayerCoordinator(playbackManager: playbackManager)
    }

    /// See the UIViewControllerRepresentable documentation for details.
    ///
    /// This implementation sets up the player view controller, changes its
    /// player to a queue player, adds an current interstitials, sets up the
    /// delegates, and performs some other tasks for a general playback setup.
    ///
    /// Outstanding items include setting up the boundary observers (quartiles,
    /// start, end, custom, etc.) and any other specific logging and
    /// notifications. An initial outline has been created for these items. See
    /// AMDVideoPlayer+Notifications and AMDVideoPlayer+VideoPlayerEvent for
    /// more information. Note that the goal of the player is not to replicate
    /// notifications already delivered by AVFoundation's AVPlayer, AVPlayerItem,
    /// etc.
    ///
    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        do {
                    let session = AVAudioSession.sharedInstance()
                    // Configure the app for playback of long-form movies.
                    try session.setCategory(.playback, mode: .moviePlayback)
                } catch {
                    // TODO: Confer with product
                    // The correct response to this may be simply deploying an
                    // error screen, retrying, etc.
                }
        let player = AVQueuePlayer()
        playbackManager.player = player
        playbackManager.eventController = AVPlayerInterstitialEventController(primaryPlayer: player)
        let playbackItems = playbackManager.nextPlayerItems()
        playbackItems.forEach{ player.insert($0, after: nil) }
        if let eventController = playbackManager.eventController,
            let interstitials = ((playbackManager as? AMDInterstitialCoordinator)?
                .interstitialEvents(for: playbackItems)) {
            eventController.events.append(contentsOf: interstitials)
        }
        
        let controller = AVPlayerViewController()
        controller.delegate = context.coordinator
        controller.player = player
        coordinator.playerController = controller
        playbackManager.playbackController = controller
        
        return controller
    }
    
    /// See the UIViewControllerRepresentable documentation for details.
    ///
    public func updateUIViewController(_ uiViewController: AVPlayerViewController,
                                context: Context) {
        
    }
    
    
    /// See the UIViewControllerRepresentable documentation for details.
    ///
    public static func dismantleUIViewController(_ uiViewController: AVPlayerViewController,
                                          coordinator: AMDVideoPlayerCoordinator) {
        
    }
    
    /// See the UIViewControllerRepresentable documentation for details.
    ///
    /// Returns the coordinator created during initialization.
    public func makeCoordinator() -> Coordinator {
        return coordinator
    }
    
}

