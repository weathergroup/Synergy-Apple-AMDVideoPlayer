//
//  AMDUserInterfaceCoordinator.swift
//
//

import SwiftUI
import AVKit
import Combine

extension AMDVideoPlayerCoordinator {
    public func playerViewController(_ playerViewController: AVPlayerViewController, 
                              willTransitionToVisibilityOfTransportBar visible: Bool,
                              with coordinator: any AVPlayerViewControllerAnimationCoordinator) {
        userInterfaceCoordinator?.transportBarWillTransition(to: visible,
                                                             using: coordinator)
    }
}


/// Declares the required properties and methods for an object behaving as an
/// AMDUserInterfaceCoordinator.
///
/// A user interface coordinator for an AMDVideoPlayer responds to user
/// interface (UI) configuration changes and through its userInterfaceConfiguration
/// property provides a means of providing both initial and updated UI
/// configuration.
public protocol AMDUserInterfaceCoordinator: AnyObject {
    
    /// The currently requestsed user interface configuration for the video
    /// player
    ///
    var userInterfaceConfiguration: AMDVideoPlayerUIConfiguration { get }
    
    /// The user interface coordinator is signaled that the transport bar
    /// will change its visibility when the video player coordinator calls this
    /// method.
    ///
    /// Use the animation coordinator to synchronize other animations with the
    /// transport bars appearance or disappearance.
    ///
    func transportBarWillTransition(to visible: Bool,
                                    using coordinator: AVPlayerViewControllerAnimationCoordinator)
}


/// Represents the current configuration requested by the playback manager.
///
/// The coordinator will observe changes to these properties and refelect them
/// in the player user interface. These properties correspond to the
/// settings available in the AVPlayerViewController.
///
/// This class is not suitable for subclassing.
///
public final class AMDVideoPlayerUIConfiguration {
    
    @Published var contentOverlay: (any View)?
    
    @Published var transportBarDisplayOptions: AMDUIOptions?
    
    @Published var transportBarMenuElements: [UIMenuElement]?
    
    @Published var customInfoViews: [any View]?
    
    @Published var infoViewActions: [UIAction]?
    
    @Published var contextualActions: [UIAction]?
    
    @Published var contextualActionsInfo: [any View]?
    
    @Published var contextualActionPreviewImage: ImageResource?
    
    @Published var swipeUpOverlay: (any View)?
    
    public init(contentOverlay: (any View)? = nil, transportBarDisplayOptions: AMDUIOptions? = nil, transportBarMenuElements: [UIMenuElement]? = nil, customInfoViews: [any View]? = nil, infoViewActions: [UIAction]? = nil, contextualActions: [UIAction]? = nil, contextualActionsInfo: [any View]? = nil, contextualActionPreviewImage: ImageResource? = nil, swipeUpOverlay: (any View)? = nil) {
        self.contentOverlay = contentOverlay
        self.transportBarDisplayOptions = transportBarDisplayOptions
        self.transportBarMenuElements = transportBarMenuElements
        self.customInfoViews = customInfoViews
        self.infoViewActions = infoViewActions
        self.contextualActions = contextualActions
        self.contextualActionsInfo = contextualActionsInfo
        self.contextualActionPreviewImage = contextualActionPreviewImage
        self.swipeUpOverlay = swipeUpOverlay
    }
}


/// Represents the available transport bar and metadata configuration options
/// provided by the AMDVideoPlayer.
///
/// See the documentation for the AVPlayerView Controller for a complete
/// description of these options as they correspond to the property settings
/// available on that class.
///
extension AMDVideoPlayerUIConfiguration {
    public struct AMDUIOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let showsPlaybackControls        = AMDUIOptions(rawValue: 1 << 0)
        static let showsTransportBar            = AMDUIOptions(rawValue: 1 << 1)
        static let showsInfoViews               = AMDUIOptions(rawValue: 1 << 2)
        static let showsTransportBarTitleView   = AMDUIOptions(rawValue: 1 << 3)
    }
}
