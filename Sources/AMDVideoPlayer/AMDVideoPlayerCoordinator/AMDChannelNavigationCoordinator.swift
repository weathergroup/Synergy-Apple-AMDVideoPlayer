//
//  AMDChannelNavigationCoordinator.swift
//
//
//

import SwiftUI
import AVKit
import Combine

// TODO: Should the async methods be cancellable?

/*
 This extension defines the delegate methods used by the AVPlayerViewController
 object of an AMDVideoPlayer instance for channel navigation. As of iOS 16, this
 is only supported on tvOS and is excluded from compilation in iOS builds.
 
 See the documentation for the AMDChannelNavigationCoordinator for additional
 details.
 */
#if os(tvOS)
extension AMDVideoPlayerCoordinator {
    
    /*
     Delegate implementation.
     */
    public func playerViewControllerSkipToNextChannel(_ playerViewController: AVPlayerViewController) async -> Bool {
        
        /*
         It's necessary to check all inputs of this method because, as a
         delegate method it must be public and non-isolated, and therefore is
         legally callable from any thread and any object.
         */
        guard let channelNavigationCoordinator,
              let player = await playerViewController.player,
              let playerItem = player.currentItem
        else { return false }
        
        /*
         Call and await a player item representing the next channel. If one is
         not delivered, the fail the channel change and return false.
         */
        guard let newPlayerItem = await channelNavigationCoordinator.skipToNextChannel(from: playerItem)
        else { return false }
        
        player.replaceCurrentItem(with: newPlayerItem)
        player.play()
        await playerViewController.dismiss(animated: false)
        return true
    }
    
    /*
     Delegate implementation.
     */
    public func playerViewControllerSkipToPreviousChannel(_ playerViewController: AVPlayerViewController) async -> Bool {
        
        /*
         It's necessary to check all inputs of this method because, as a
         delegate method it must be public and non-isolated, and therefore is
         legally callable from any thread and any object.
         */
        guard let channelNavigationCoordinator,
              let player = await playerViewController.player,
              let playerItem = player.currentItem
        else { return false }
        
        /*
         Call and await a player item representing the next channel. If one is
         not delivered, the fail the channel change and return false.
         */
        guard let newPlayerItem = await channelNavigationCoordinator.skipToPreviousChannel(from: playerItem)
        else { return false }
        
        player.replaceCurrentItem(with: newPlayerItem)
        player.play()
        await playerViewController.dismiss(animated: false)
        return true
    }
    
    /*
     Delegate implementation.
     */
    public func nextChannelInterstitialViewController(for playerViewController: AVPlayerViewController) -> UIViewController {
        /*
         It's necessary to check all inputs of this method because, as a
         delegate method it must be public and non-isolated, and therefore is
         legally callable from any thread and any object.
         */
        guard let channelNavigationCoordinator,
              let playerItem = playerViewController.player?.currentItem
        else { return defaultInterstitialController }
        
        /*
         Not all channels may have interstitials. If they don't, we always
         return the default interstitial.
         */
        guard let imageResource = channelNavigationCoordinator
                                    .nextChannelInterstitial(from: playerItem)
        else { return defaultInterstitialController }
        
        /*
         While the AVPlayerViewController uses UIKit based objects, the
         coordinator always constructs objects using SwiftUI and then wraps them
         in a hosting controller or hosted view.
         */
        let imageView = Image(imageResource)
        return UIHostingController(rootView: imageView)
    }
    
    /*
     Delegate implementation.
     */
    public func previousChannelInterstitialViewController(for playerViewController: AVPlayerViewController) -> UIViewController {
        
        /*
         It's necessary to check all inputs of this method because, as a
         delegate method it must be public and non-isolated, and therefore is
         legally callable from any thread and any object.
         */
        guard let channelNavigationCoordinator,
              let playerItem = playerViewController.player?.currentItem
        else { return defaultInterstitialController }
        
        /*
         Not all channels may have interstitials. If they don't, we always
         return the default interstitial.
         */
        guard let imageResource = channelNavigationCoordinator
                                    .previousChannelInterstitial(from: playerItem)
        else { return defaultInterstitialController }
        
        /*
         While the AVPlayerViewController uses UIKit based objects, the
         coordinator always constructs objects using SwiftUI and then wraps them
         in a hosting controller or hosted view.
         */
        let imageView = Image(imageResource)
        return UIHostingController(rootView: imageView)
    }
    
    /*
     Provides an indeterminate progress SwiftUI view wrapped in a UIKit hosting
     controller as the default interstitial controller when making a channel
     change.
     */
    private var defaultInterstitialController: 
        UIHostingController<ProgressView<EmptyView, EmptyView>> {
        get {
            let progressView = ProgressView()
            return UIHostingController(rootView: progressView)
        }
    }
}
#endif

/// The AMDChannelNavigationCoordinator defines the API for coordinating live
/// stream playback channel navigation on tvOS.
///
/// Currently only available on tvOS, live stream channel navigation enables
/// the user to use the remote to "channel surf" among contiguous channels
/// provided by a service. Each channel has an optional channel interstitial
/// that can be presented as live streams load, with the default being an
/// indeterminate spinner on a dark background.
///
/// The protocol defines two related pairs of methods:
/// - A next and a previous method for defining a related interstitial image
/// - A next and a previous method for defining a channel to switch to
///
///
public protocol AMDChannelNavigationCoordinator: AnyObject {
    
    /// Provides an image to be used as an intersitial while a player item
    /// resource is being loaded in response to a channel change event loading
    /// the next channel.
    ///
    /// A channel may provide an representatve image that should be displayed
    /// while the stream resource for the channel is being loaded by the app.
    /// This method is called on the channel navigation coordinator in response
    /// to a call to the player view controller delegate requesting a
    /// UIViewController that should be used to display an appropriate
    /// interstitial.
    ///
    /// When this method returns an image resource object, that is image is
    /// wrapped in a hosting controller and used for an interstitial
    /// presentation while the channel's stream resource is loading. If this
    /// method returns nil, a default indeterminate progress indicator is
    /// presented while the channel's stream resource is loading.
    ///
    func nextChannelInterstitial(from playerItem: AVPlayerItem) -> ImageResource?
    
    /// Provides an image to be used as an intersitial while a player item
    /// resource is being loaded in response to a channel change event loading
    /// the previous channel.
    ///
    /// A channel may provide an representatve image that should be displayed
    /// while the stream resource for the channel is being loaded by the app.
    /// This method is called on the channel navigation coordinator in response
    /// to a call to the player view controller delegate requesting a
    /// UIViewController that should be used to display an appropriate
    /// interstitial.
    ///
    /// When this method returns an image resource object, that is image is
    /// wrapped in a hosting controller and used for an interstitial
    /// presentation while the channel's stream resource is loading. If this
    /// method returns nil, a default indeterminate progress indicator is
    /// presented while the channel's stream resource is loading.
    ///
    func previousChannelInterstitial(from playerItem: AVPlayerItem) -> ImageResource?
    
    /// Requests an AVPlayerItem to be used for playing the next channel
    /// relative to the passed in AVPlayerItem.
    ///
    /// For a tvOS app, this method should return either an AVPlayerItem that
    /// will be used to play the next channel relative to the channel
    /// passed into the method, or nil if no channel is available in this
    /// direction. Because this method is asynchronous, it is possible that the
    /// user may skip multiple channels before a requested channel is completely
    /// loaded and becomes the current channel. Therefore, determination of what
    /// the next channel is should always be made from the player item that is
    /// passed into this method, and never from the current player instance.
    ///
    func skipToNextChannel(from playerItem:AVPlayerItem) async -> AVPlayerItem?
    
    /// Requests an AVPlayerItem to be used for playing the previous channel
    /// relative to the passed in AVPlayerItem.
    ///
    /// For a tvOS app, this method should return either an AVPlayerItem that
    /// will be used to play the previous channel relative to the channel
    /// passed into the method, or nil if no channel is available in this
    /// direction. Because this method is asynchronous, it is possible that the
    /// user may skip multiple channels before a requested channel is completely
    /// loaded and becomes the current channel. Therefore, determination of what
    /// the next channel is should always be made from the player item that is
    /// passed into this method, and never from the current player instance.
    ///
    func skipToPreviousChannel(from playerItem: AVPlayerItem) async -> AVPlayerItem?
}
