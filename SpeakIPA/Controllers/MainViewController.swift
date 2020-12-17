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
    
    @IBAction func toApp(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        
        tabBarController.tabBar.tintColor = UIColor(named: "AppPurple")
        
        switch sender.accessibilityIdentifier{
        case buttons.gameButton:
            tabBarController.selectedIndex=1
        default:
            tabBarController.selectedIndex=0
        }
        
        UIApplication.shared.windows.first?.rootViewController = tabBarController
        
    }
    
    /*
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: UIButton) {
    }
     */
}
