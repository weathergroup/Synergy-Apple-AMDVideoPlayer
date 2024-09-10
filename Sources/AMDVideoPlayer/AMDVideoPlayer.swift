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
///
///
public struct AMDVideoPlayer: UIViewControllerRepresentable {
    public typealias UIViewControllerType = AVPlayerViewController
    
    @State private var playbackManager: AMDPlaybackManager
    @State private var coordinator: AMDVideoPlayerCoordinator
    
    public init(playbackManager: AMDPlaybackManager) {
        self.playbackManager = playbackManager
        self.coordinator = AMDVideoPlayerCoordinator(playbackManager: playbackManager)
    }

    
    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        do {
                    let session = AVAudioSession.sharedInstance()
                    // Configure the app for playback of long-form movies.
                    try session.setCategory(.playback, mode: .moviePlayback)
                } catch {
                    
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
        controller.showsPlaybackControls = true
        
        // Convert to on appear or other playback manager method
        return controller
    }
    
    
    public func updateUIViewController(_ uiViewController: AVPlayerViewController,
                                context: Context) {
        
    }
    
    
    public static func dismantleUIViewController(_ uiViewController: AVPlayerViewController,
                                          coordinator: AMDVideoPlayerCoordinator) {
        
    }
    
    
    public func makeCoordinator() -> Coordinator {
        return coordinator
    }
    
}

