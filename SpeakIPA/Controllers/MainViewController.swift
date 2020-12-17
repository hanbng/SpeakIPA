//
//  MainViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 11/3/20.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        transcribeButton.becomeStandard()
        secondButton.becomeStandard()
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
