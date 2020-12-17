//
//  QuizViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 12/5/20.
//

import UIKit
import Firebase
import FirebaseDatabase
import AVFoundation
import FirebaseStorage
import Lottie

class QuizViewController: UIViewController, AVAudioPlayerDelegate, UITabBarDelegate {
    
    //let questions = 5
    
    var audioPlayer: AVAudioPlayer!
    let game = Game()
    
    @IBOutlet weak var choiceOneButton: UIButton!
    @IBOutlet weak var choiceTwoButton: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        choiceOneButton.becomeStandard()
        choiceTwoButton.becomeStandard()
        
        tabBar.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        choiceOneButton.isEnabled = false
        choiceTwoButton.isEnabled = false
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        
        game.prepareForGame { (success) in
            if success {
                print("Got IPA")
            }
        }
        game.getRecords { (success) in
            if success {
                self.choiceOneButton.isEnabled = true
                self.choiceTwoButton.isEnabled = true

                self.game.shuffle()
                self.game.playRecord()
            }
        }
    }
    
    @IBAction func choose(_ sender: UIButton) {
        // let ipa = record["IPA"] as! String
        let chosenAnswer = sender.titleLabel?.text
        if game.choose(chosenAnswer: chosenAnswer ?? "") {
            sender.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        }
        
        
        if !game.canGetNextQuestion() {
            performSegue(withIdentifier: segues.toResultSegue, sender: self)
        } else {
            toNextQuestion()
        }
    }
    
    func toNextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            choiceOneButton.backgroundColor = UIColor(named: "AppYellow")
            choiceTwoButton.backgroundColor = UIColor(named: "AppYellow")
            self.game.playRecord()
        }
    }
    
    @IBAction func replayAudio(_ sender: Any) {
        game.playAudio(url: game.url!, fileName: game.fileName!)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultViewController
        vc.totalScore = self.game.totalScore
    }
}

extension QuizViewController {
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
