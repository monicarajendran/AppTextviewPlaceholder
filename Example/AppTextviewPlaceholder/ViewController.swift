//
//  ViewController.swift
//  AppTextviewPlaceholder
//
//  Created by monicarajendran on 04/02/2018.
//  Copyright (c) 2018 monicarajendran. All rights reserved.
//

import UIKit
import AppTextviewPlaceholder

class ViewController: UIViewController {
    
    @IBOutlet weak var tempTextview: AppPlaceholderTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tempTextview.placeholder = "this is placeholder"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

