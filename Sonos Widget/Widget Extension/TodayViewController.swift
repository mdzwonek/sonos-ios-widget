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
    
    var sonosManager: SonosManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 75);
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        self.sonosManager = SonosManager()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 50, 0, 0)
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
    
}
