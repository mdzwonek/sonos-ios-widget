//
//  ViewController.swift
//  Sonos Widget
//
//  Created by Mateusz Dzwonek on 11/01/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SonosManager.sharedInstance().addObserver(self, forKeyPath: "allDevices", options: .New, context: nil);
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "allDevices" {
            let devices = SonosManager.sharedInstance().allDevices();
            for device in devices {
                if let sonosDevice = device as? SonosController {
                    NSLog("%@", sonosDevice);
                }
            }
        }
    }

}

