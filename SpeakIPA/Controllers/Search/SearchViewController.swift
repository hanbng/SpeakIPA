//
//  SearchViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 11/3/20.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    var language: Language?
    
    var apiRequest = APIRequest()
    var transcription = ""
    var dict = [Int:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.becomeStandard()
    }
    
    @IBAction func onLookUp(_ sender: Any) {
        let word = textField.text!
        APIRequest.getTranscription(language: language?.code ?? "EN-US", my_word: word) { (my_transcription) in
            if let my_transcription = my_transcription {
                self.transcription = my_transcription
                print(self.transcription)
            } else {
                print("No transcription available")
            }
        }
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
