//
//  SearchViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 11/3/20.
//

import UIKit
import AVFoundation
import Firebase
import Lottie

class SearchViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    var language: Language?
    
    var apiRequest = APIRequest()
    var transcription = ""
    var audio = ""
    
    var audioPlayer: AVAudioPlayer!
    
    let dictRef = Storage.storage().reference().child("Dictionaries") // Reference to folder of IPA txt files
    var contents = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.isHidden = false
        // 1. Set animation content mode
        
        animationView.contentMode = .scaleAspectFit
        
        // 2. Set animation loop mode
        
        animationView.loopMode = .loop
        
        // 3. Adjust animation speed
        
        animationView.animationSpeed = 0.5
        
        // 4. Play animation
        animationView.play()
        
        searchButton.becomeStandard()
        
        // Get the txt file from Firebase Cloud Storage if the language is not English
        let chosenLanguage = language!.name
        if chosenLanguage != "British English" && chosenLanguage != "American English" {
            downloadTxtFile { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.animationView.stop()
                        self.animationView.isHidden = true
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
                animationView.stop()
                animationView.isHidden = true
            }
        }
    }
    
    @IBAction func onLookUp(_ sender: UIButton) {
        sender.backgroundColor = UIColor(named: "AppYellow")
        let word = textField.text!
        let chosenLanguage = language!.name
        if chosenLanguage == "British English" || chosenLanguage == "American English" {
            englishLookUp(word: word)
        } else {
            otherLookUp(word: word)
        }
        //sender.backgroundColor = UIColor(named: "AppPurple")
    }
    
    func downloadTxtFile(completion: @escaping (Bool) -> Void) {
        let dictionary = language!.code
        let fileName = dictionary!+".txt"
        let fileRef = dictRef.child(fileName)
        
        // Get the download Url of the text file
        fileRef.downloadURL { (url, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else if url != nil {
                print(url)
                self.downloadTxtFileFromUrl(url: url!){ (success) in
                    if success {
                        return completion(true)
                    }
                }
            }
        }
    }
    
    func downloadTxtFileFromUrl(url: URL, completion: @escaping (Bool) -> Void) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URLData, response, error) -> Void in
            do {
                self!.contents = try String(contentsOf: url)
                return completion(true)
            } catch let err {
                print(err.localizedDescription)
                return
            }
        })
        downloadTask.resume()
    }
    
    func otherLookUp(word: String) {
        let lines = self.contents.split(separator: "\n")
        let line = lines.first(where: { (result) -> Bool in
            let elements = result.split(separator: "\t")
            let entry = elements[0];
            let transcription = elements[1]
            if entry == word {
                self.transcription = String(transcription)
                return true
            } else {
                return false
            }
        })
        if line != nil {
            self.transcriptionLabel.text = self.transcription
        } else {
            self.transcriptionLabel.text = "No transcription available"
        }
    }
    
    func englishLookUp(word: String) {
        searchButton.isEnabled = false
        APIRequest.getTranscription(language: language?.code ?? "EN-US", my_word: word) { (my_transcription, my_audio) in
            if let my_transcription = my_transcription, let my_audio = my_audio {
                self.transcription = my_transcription
                self.audio = my_audio
            } else {
                print("No transcription available")
            }
            DispatchQueue.main.async {
                if self.transcription.isEmpty {
                    self.transcriptionLabel.text = "No transcription available"
                    self.searchButton.isEnabled = true
                    return
                }
                self.transcriptionLabel.text = "/\(self.transcription)/"
                self.playAudio(urlStr: self.audio)
                self.searchButton.isEnabled = true
                self.playAudioButton.isEnabled = true
                
            }
        }
    }
    
    @IBAction func replayAudio(_ sender: Any) {
        if !transcription.isEmpty {
            playAudio(urlStr: self.audio)
        }
    }
    
    func playAudio(urlStr: String) {
        if let url = URL(string: urlStr) {
            downloadAudioFileFromUrl(url: url)
        }
    }
    
    func downloadAudioFileFromUrl(url: URL) {
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (url, response, error) -> Void in
            do {
                let player = try AVAudioPlayer(contentsOf: url!)
                self?.audioPlayer = player
                self?.audioPlayer.prepareToPlay()
                self?.audioPlayer.play()
            } catch let err {
                print(err.localizedDescription)
            }
        })
        downloadTask.resume()
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
