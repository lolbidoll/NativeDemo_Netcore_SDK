//
//  ViewController.swift
//  NativeDemoApp
//
//  Created by Tanay Mitkari on 26/02/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func myButton(_ sender: UIButton) {
        if let innerPageVC = storyboard?.instantiateViewController(withIdentifier: "InnerPageViewController") as? InnerPageViewController {
//            innerPageVC.modalPresentationStyle = .fullScreen
            self.present(innerPageVC, animated: true)
//            self.navigationController?.pushViewController(innerPageVC, animated: true)
           }
    }
    
    
}

