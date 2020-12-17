//
//  IPAModifier.swift
//  SpeakIPA
//
//  Created by nguyen thy on 12/14/20.
//

import Foundation
import FirebaseDatabase
import Firebase

class IPAModifier {
    var databaseRef = Database.database().reference()
    
    var ipaChart = [Sound]()
    
    func getIpaChart(completion: @escaping(Bool) -> Void) {
        databaseRef.child("ipa").observeSingleEvent(of: .value) { (snapshot) in
            if let ipaChart = snapshot.value as? NSArray {
                for element in ipaChart {
                    let sound = element as! [String:Any]
                    let symbolStr = sound["symbol"] as! String
                    let symbol = Array(symbolStr)[0]
                    let manner = sound["symbol"] as? String
                    let place = sound["place"] as? String
                    let voiced = sound["voiced"] as! Bool
                    let isConsonant = sound["consonant"] as! Bool
                    let newSound = Sound(symbol: symbol, manner: manner, place: place, voiced: voiced, isConsonant: isConsonant)
                    self.ipaChart.append(newSound)
                }
                return completion(true)
            }
        }
    }
    
    // Returns an IPA with Levenshtein distance of 1
    func minumumModify(correctIPA: String) -> String {
        var wrongIPA = ""
        var characters = Array(correctIPA)
        var index = Int.random(in: 0..<characters.count)
        changeChar(characters: &characters, index: &index)
        wrongIPA = String(characters)
        return wrongIPA
    }
    
    
    // Changes a character in an array of characters
    func changeChar(characters: inout [Character], index: inout Int) {
        var character = characters[index]
        
        // Character is a white space, need to rechoose the index
        while character.isWhitespace  {
            index = Int.random(in: 0..<characters.count) // Change the index
            character = characters[index]
        }
        
        print(character, index)
        // Sound object of current character
        let sound = ipaChart.first(where: {$0.symbol == character})
        if sound != nil {
            
            // A consonant, replace with a similar one
            if sound!.isConsonant {
                let wrongSound = similarConsonant(original: sound!)
                characters[index] = wrongSound
            } else {
                // A vowel, replace with a similar one
                let wrongSound = similarVowel(original: sound!)
                characters[index] = wrongSound
            }
            
        // Special character
        } else {
            print("Special Character")
            
            switch character {
            case "ː":
                // Replace long vowel symbol with another vowel
                var newPreSound: Sound
                let preChar = characters[index-1]

                repeat {
                    newPreSound = ipaChart.randomElement()!
                } while newPreSound.symbol == preChar || newPreSound.isConsonant
                characters[index-1] = newPreSound.symbol
                
            case "'":
                // Move stress symbol to other places
                characters.remove(at: index)
                var newStressIndex: Int
                repeat {
                    newStressIndex = Int.random(in: 0..<characters.count)
                } while newStressIndex == index
                characters.insert(character, at: newStressIndex)
                
            case "ʰ":
                // Change the aspirated sound
                let preChar = characters[index-1]
                let preSound = ipaChart.first(where: {$0.symbol == preChar})
                characters[index-1] = similarConsonant(original: preSound!)
                
            default:
                // Change sounds not documented
                //let preChar = characters[index]
                //let preSound = ipaChart.first(where: {$0.symbol == preChar})
                //characters[index] = similarConsonant(original: preSound!)
                characters[index] = ipaChart.randomElement()!.symbol
            }
        }
    }
    
    func similarConsonant(original: Sound) -> Character {
        let new = ipaChart.first { (sound) -> Bool in
            if  sound.symbol != original.symbol &&
                ((sound.manner == original.manner && sound.place == original.place) ||
                sound.place == original.place) {
                return true
            } else {
                return false
            }
        }
        
        return new!.symbol
    }
    
    func similarVowel(original:Sound) -> Character {
        var new: Sound
        repeat {
            new = ipaChart.randomElement()!
        } while new.symbol == original.symbol || new.isConsonant
        return new.symbol
    }
}

extension StringProtocol {
    public subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
