//
//  ResultViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 12/5/20.
//

import UIKit
import Lottie

class ResultViewController: UIViewController {
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var totalScore = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        
        let highestScore = defaults.integer(forKey: "HighestScore")
        
        totalScoreLabel.text = "\(totalScore)"
        highestScoreLabel.text = "\(highestScore)"
        
        if totalScore > highestScore {
            defaults.set(totalScore, forKey: "HighestScore")
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.highestScoreLabel.text = "\(self.totalScore)"
            }
        }
        
        // 1. Set animation content mode
        animationView.contentMode = .scaleAspectFit
        
        // 2. Set animation loop mode
        animationView.loopMode = .loop
        
        // 3. Adjust animation speed
        animationView.animationSpeed = 0.5
        
        // 4. Play animation
        animationView.play()
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

extension ResultViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let title = item.title
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
        tabBarController.tabBar.tintColor = UIColor(named: "AppPurple")
        if title == "Search" {
            tabBarController.selectedIndex = 0
        } else {
            tabBarController.selectedIndex = 1
        }
        UIApplication.shared.windows.first?.rootViewController = tabBarController
    }
}
