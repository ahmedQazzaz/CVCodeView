//
//  ViewController.swift
//  anbddde
//
//  Created by Ahmed Qazzaz on 5/10/18.
//  Copyright © 2018 Ahmed Qazzaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CVCodeViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishEnterCode(field: CVCodeView, text: String) {
        print(text)
    }


}

