//
//  ViewController.swift
//  MbCircularProgress
//
//  Created by Viorel Porumbescu on 19/02/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var progressView: MBCircularProgressView!
    @IBOutlet weak var pv: MBCircularProgressView!
    @IBOutlet weak var pv2: MBCircularProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func setNewValue(_ sender: NSSlider) {
        progressView.floatValue = sender.floatValue
         pv.floatValue = sender.floatValue
         pv2.floatValue = sender.floatValue
    }
    

    
    
    
}

