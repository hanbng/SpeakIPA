//
//  GetStartedViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 12/5/20.
//

import UIKit
class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedButton.becomeStandard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
