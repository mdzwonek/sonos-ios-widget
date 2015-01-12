//
//  TodayViewController.swift
//  Widget Extension
//
//  Created by Mateusz Dzwonek on 11/01/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var previousSongButton: UIButton?
    @IBOutlet var nextSongButton: UIButton?
    @IBOutlet var playPauseButton: UIButton?
    @IBOutlet var volumeUpButton: UIButton?
    @IBOutlet var volumeDownButton: UIButton?
    @IBOutlet var volumeImageView: UIImageView?
    
    var sonosManager: SonosManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 75)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        self.setEnabled(false)
        self.sonosManager?.removeObserver(self, forKeyPath: "currentDevice")
        self.sonosManager = SonosManager()
        self.sonosManager?.addObserver(self, forKeyPath: "currentDevice", options: .New, context: nil)
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 50, 0, 0)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentDevice" {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.setEnabled(true)
            })
        }
    }
    
    func setEnabled(enabled: Bool) {
        for button in [ self.previousSongButton, self.nextSongButton, self.playPauseButton, self.volumeUpButton, self.volumeDownButton ] {
            button?.enabled = enabled
        }
        self.volumeImageView?.alpha = enabled ? 1.0 : 0.5
    }
    
    @IBAction func didTapPreviousButton() {
        self.sonosManager?.currentDevice?.previous(nil)
    }
    
    @IBAction func didTapPlayPauseButton() {
        self.sonosManager?.currentDevice?.togglePlayback(nil)
    }
    
    @IBAction func didTapNextButton() {
        self.sonosManager?.currentDevice?.next(nil)
    }
    
    @IBAction func didTapVolumeUpButton() {
        self.changeVolume(1)
    }
    
    @IBAction func didTapVolumeDownButton() {
        self.changeVolume(-1)
    }
    
    private func changeVolume(volumeDelta: NSInteger) {
        self.sonosManager?.currentDevice?.getVolume({ (volume, response, error) -> Void in
            if error == nil {
                self.sonosManager?.currentDevice?.setVolume(volume + volumeDelta, completion: nil)
            }
        })
    }
    
    deinit {
        self.sonosManager?.removeObserver(self, forKeyPath: "currentDevice")
    }
    
}
