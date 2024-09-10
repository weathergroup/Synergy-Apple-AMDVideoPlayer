//
//  AMDPlaybackManager.swift
//  
//
//

import Foundation
import SwiftUI
import AVKit
import Combine

/// The AMDPlaybackManagable protocol defines the minimum set of required methods
/// for video playback using the SwiftUI AMDVideoPlayer.
///
/// 
public protocol AMDPlaybackManagable: AnyObject {
    
    /// Returns the next player item or items for the AMDVideoPlayer, if any.
    ///
    /// The nextPlayerItem method is called by AVVideoPlayer when it reaches
    /// the last player item in its queue. The player will attempt to preload
    /// the next player item in its queue to provide smooth playback and
    /// seamless transitions between player items.
    ///
    /// Depending on the configuration of the playback manager, returning an
    /// empty array from this method will cause the AMDVideoPlayer instance to
    /// dismiss itself on playback completion.
    ///
    func nextPlayerItems() -> [AVPlayerItem]
    
    /// The player used by the AMDVideoPlayer instance.
    ///
    /// This property will be set by the AMDVideoPlayer as part of its creation
    /// of an AVVideoPlayerController object.
    ///
    var player: AVQueuePlayer? { get set }
    
}


/// Defines the root class expected by the AMDVideoPlayer that implements the
/// AMDPlaybackManagable protocol.
///
/// All playback managers should inherit from this base class, overriding its
/// methods and adding extensions for relevant coordinator types.
open class AMDPlaybackManager: AMDPlaybackManagable, ObservableObject {
    
    /// Default implementation returnign no items.
    ///
    /// See the protocol documentation.
    open func nextPlayerItems() -> [AVPlayerItem] {
        return []
    }
    
    /// A reference to the video players underlying AVQueuePlayer.
    ///
    /// The property is published, enabling its setting to be observed, and
    /// thereby used as a trigger for other actions. In the current
    /// implementation, a didSet observer is directly attached to the property
    /// to trigger setting up observation of the player itself (as opposed to
    /// just whether the player property has been set on the playback manager).
    /// It's likely that the didSet should be removed and the client should be
    /// responsible for setting up its observation.
    @Published public var player: AVQueuePlayer? = nil {
        didSet {
            self.observePlayer()
        }
    }
    
    
    /// A reference to the underlying player view controller used within the
    /// wrapper.
    ///
    /// #Note
    /// Over time, the features provided by the wrapper
    /// should be moved to one of the coordinator specializations, enabling the
    /// base video player coordinator to act as the interface between the
    /// player view controller and the playback logic implemented by the client
    /// app. This is also helpful in providing a clean and consistent separation
    /// between the UIKit/AVKit portion of the framework and the current and
    /// future SwiftUI portion of the framework.
    ///
    public unowned var playbackController: AVPlayerViewController?
    
    /// The interstitial event controller attached to the player.
    ///
    /// Add all interstitial events for the video player to this controller.
    public var eventController: AVPlayerInterstitialEventController?
    
    /// Provides instance level storage for Combine flows.
    public var cancellables = Set<AnyCancellable>()
    
    /*
     Once this framework is complete, this reference may be unnecessary, but is
     useful during development.
     */
    private var playerObserverRef: ()? = nil
    
    
    /// By default, the Playback Manager uses a zero parameter init. This is
    /// useful as the manager will generally be in place prior to some of its
    /// properties being available to be set.
    ///
    /// #Note
    /// In the current implementation, many properties are set as optional.
    /// However, it may be possible to guarantee property availability prior to
    /// access, in which as properties could be marked as "!", enabling them
    /// to be set after init while being non-optional. Note that this will mean
    /// failure to set them will crash the app, but in this case it would be a
    /// fatal playback error so this may be a useful trigger to have in the
    /// program.
    ///
    public init() { }
    
    
    /*
     For the moment, playback is initiated when the player status becomes ready.
     Once the framework is complete, it would better to let the consumer of the
     API do the playback triggering as there may be intervening things that need
     to be presented before playback begins but after playback is madeready.
     
     This is solely for development purposes and should be removed once the
     framework reaches production viability.
     */
    private func observePlayer() {
        guard playerObserverRef == nil else { return }
        self.playerObserverRef = self.player?
            .publisher(for: \.status)
            .drop(while: { $0 != .readyToPlay} )
            .sink(receiveValue: { _ in
                self.player?.play()
            })
            .store(in: &cancellables)
    }
    
}
