//
//  AMDVideoPlayer+Notifications.swift
//
//
//

import SwiftUI
import AVKit
import Combine


extension AMDVideoPlayer {
    
    /// A player has begun loading and playback of an interstitial video.
    ///
    /// The notification object is the player item.
    public static let InterstitialBegan: Notification.Name =
    Notification.Name(rawValue: VideoPlayerEvent.InterstitialBegan.rawValue)
    
    /// A player has completed playback of an interstitial video.
    ///
    /// The notification object is the player item.
    public static let InterstitialEnded: Notification.Name =
    Notification.Name(rawValue: VideoPlayerEvent.InterstitialEnded.rawValue)
    
    /// A player has crossed a quartile boundary of a player item.
    ///
    /// The notification object is the player item. The user info dictionary
    /// contains the quartile identifier that was traversed along with the
    /// playback time the quartile was traversed.
    public static let QuartileBegan: Notification.Name =
    Notification.Name(rawValue: VideoPlayerEvent.QuartileBegan.rawValue)
    
    /// A player is changing the player item to the next channel.
    ///
    /// The notification object is the player and the user info dictionary
    /// contains the old and new player items.
    public static let SkipToNextChannel: Notification.Name =
    Notification.Name(rawValue: VideoPlayerEvent.SkipToNextChannel.rawValue)
    
    /// A player is changing the player item to the previous channel.
    ///
    /// The notification object is the player and the user info dictionary
    /// contains the old and new player items.
    public static let SkipToPreviousChannel: Notification.Name =
    Notification.Name(rawValue: VideoPlayerEvent.SkipToPreviousChannel.rawValue)
    
}

extension AMDVideoPlayer {
    
    enum LogKey: String {
        case AccessLog
        case ErrorLog
    }
    
}

extension AMDVideoPlayer {
        
    /// Produces a notification object corresponding to a video event on
    /// the player item.
    static func notification(for event: VideoPlayerEvent,
                      on playerItem: AVPlayerItem,
                      accessLog: AVPlayerItemAccessLog?,
                      errorLog: AVPlayerItemErrorLog?) -> Notification {
        
        var userInfo = [AMDVideoPlayer.LogKey: Any]()
        if let accessLog { userInfo[.AccessLog] = accessLog }
        if let errorLog { userInfo[.ErrorLog] = errorLog }
        
        return Notification(name: event.notificationName,
                            object: playerItem,
                            userInfo: userInfo)
    }
    
}
