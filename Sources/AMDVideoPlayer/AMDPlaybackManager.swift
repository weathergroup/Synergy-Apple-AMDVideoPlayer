//
//  File.swift
//  
//
//  Created by Erik Heath Thomas on 8/23/24.
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
    open func nextPlayerItems() -> [AVPlayerItem] {
        return []
    }
    
    @Published public var player: AVQueuePlayer? = nil {
        didSet {
            self.observePlayer()
        }
    }
    
    public unowned var playbackController: AVPlayerViewController?
    
    public var eventController: AVPlayerInterstitialEventController?
    
    public var cancellables = Set<AnyCancellable>()
    
    private var playerObserverRef: ()? = nil
    
    public init() { }
    
    func observePlayer() {
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
