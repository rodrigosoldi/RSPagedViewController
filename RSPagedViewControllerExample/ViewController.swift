//
//  ViewController.swift
//  RSPagedViewControllerExample
//
//  Created by Rodrigo Soldi on 12/07/18.
//  Copyright © 2018 Soldi Inc. All rights reserved.
//

import UIKit
import RSPagedViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapButton(_ sender: Any) {
        
        let pagedViewController = RSPagedViewController()
        pagedViewController.delegate = self
     
        self.navigationController?.pushViewController(pagedViewController, animated: true)
    }
    
}

extension ViewController: RSPagedViewControllerDelegate {
    
    func viewControllersForDisplay(pagedViewController: RSPagedViewController) -> [UIViewController] {
        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "vc1")
        let vc2 = self.storyboard!.instantiateViewController(withIdentifier: "vc2")
        let vc3 = self.storyboard!.instantiateViewController(withIdentifier: "vc3")
        
        return [vc1, vc2, vc3]
    }
    
    func titlesForDisplay(pagedViewController: RSPagedViewController) -> [String] {
        return ["VC 1", "VC 2", "VC 3"]
    }
    
}

