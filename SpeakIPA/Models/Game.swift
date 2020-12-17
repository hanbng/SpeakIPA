//
//  Game.swift
//  SpeakIPA
//
//  Created by nguyen thy on 12/5/20.
//

import Foundation
import Firebase
import FirebaseDatabase
import AVFoundation
import FirebaseStorage

class Game {
    let storage = Storage.storage()
    var databaseRef = Database.database().reference()
    var records = [[String:Any]]()
    
    var record = [String:Any]()
    var questionNumber = 0
    var questions = 10
    var totalScore = 0
    
    var delegate: QuizViewController!
    
    var ipaModifier = IPAModifier()
    
    var url:URL?
    var fileName:String?
    
    init(questions: Int = 10) {
        self.totalScore = 0
        self.questions = questions
    }
    
    // Shuffle the records
    func shuffle() {
        records = records.shuffled()
    }
    
    func prepareForGame(completion: @escaping(Bool) -> Void) {
        ipaModifier.getIpaChart { (success) in
            if success {
                return completion(true)
            }
        }
    }
    
    // Get all the sound records
    func getRecords(completion: @escaping(Bool) -> Void) {
        databaseRef.child("records").observe(.value) { (snapshot) in
            if let records = snapshot.value as? [[String:Any]] {
                for record in records {
                    self.records.append(record)
                }
                return completion(true)
            }
        }
    }
    
    // Play a record and display questions
    func playRecord() {
        let record = records[questionNumber]
        
        let language = record["language"] as! String
        let definition = record["definition"] as! String
        let urlString = record["url"] as! String
        let ipa = record["modifiedIPA"] as! String
        let wrongIPA = ipaModifier.minumumModify(correctIPA: ipa)
        
        self.record = record
        let number = Int.random(in: 1..<3)
        if number == 1 {
            delegate.choiceOneButton.setTitle(ipa, for: .normal)
            delegate.choiceTwoButton.setTitle(wrongIPA, for: .normal)
        } else {
            delegate.choiceTwoButton.setTitle(ipa, for: .normal)
            delegate.choiceOneButton.setTitle(wrongIPA, for: .normal)
        }
        
        let recordRef = storage.reference(forURL: urlString)
        fileName = language + "-\(definition).m4a"
        recordRef.downloadURL { (my_url, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else if my_url != nil {
                self.url = my_url!
                self.playAudio(url: self.url!, fileName: self.fileName!)
            }
        }
    }
    
    // Play an audio file
    func playAudio(url: URL, fileName: String) {
        let docUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let desURL = docUrl.appendingPathComponent(fileName)
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URLData, response, error) -> Void in
            do{
                let isFileFound:Bool? = FileManager.default.fileExists(atPath: desURL.path)
                if isFileFound == true{
                    //print(desURL) //delete tmpsong.m4a & copy
                } else {
                    try FileManager.default.copyItem(at: URLData!, to: desURL)
                }
                let sPlayer = try AVAudioPlayer(contentsOf: desURL)
                self?.delegate.audioPlayer = sPlayer
                self?.delegate.audioPlayer.prepareToPlay()
                
                self?.delegate.animationView.play()
                self?.delegate.audioPlayer.play()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self?.delegate.animationView.stop()
                }
                    
            }catch let err {
                print(err.localizedDescription)
            }
            
        })
        downloadTask.resume()
    }
    
    // Returns a bool if a choosen answer is a correct ipa
    func choose(chosenAnswer: String) -> Bool {
        let correctIPA = record["modifiedIPA"] as! String
        if chosenAnswer == correctIPA {
            totalScore += 1
            questionNumber += 1
            return true
        } else {
            questionNumber += 1
            return false
        }
    }
    
    // Returns a bool if all questions are used
    func canGetNextQuestion() -> Bool {
        if (questionNumber == questions) {
            return false
        } else {
            return true
        }
    }
}

