//
//  Sound.swift
//  SpeakIPA
//
//  Created by nguyen thy on 12/13/20.
//

import Foundation

class Sound {
    var symbol: Character
    var manner: String?
    var place: String?
    var voiced: Bool
    var isConsonant: Bool
    
    init(symbol: Character, manner: String? = nil, place: String? = nil, voiced: Bool, isConsonant: Bool) {
        self.symbol = symbol
        self.manner = manner
        self.place = place
        self.voiced = voiced
        self.isConsonant = isConsonant
    }
}
