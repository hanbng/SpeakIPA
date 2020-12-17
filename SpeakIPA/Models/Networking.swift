//
//  Networking.swift
//  SpeakIPA
//
//  Created by nguyen thy on 10/30/20.
//

import Foundation

struct APIRequest {
    static func getTranscription(language: String, my_word:String, completion: @escaping (String?) -> Void) {
        let appId = "a607e7f6"
        let appKey = "fdd0afebd8d10b456da0ade9ebd0eaeb"
        let language = language.lowercased()
        let word_id = my_word.lowercased()
        let fields = "pronunciations"
        let strictMatch = "false"
        var transcription = ""
        
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/entries/\(language)/\(word_id)?fields=\(fields)&strictMatch=\(strictMatch)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { data, response, error in
            if let _ = response,
                let data = data,
                let jsonData = try? (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]) {
                let results = jsonData["results"] as! [[String:Any]]
                let lexicalEntries = results[0]["lexicalEntries"] as! [[String:Any]]
                let entries = lexicalEntries[0]["entries"] as! [[String:Any]]
                let pronunciations = entries[0]["pronunciations"] as! [[String:Any]]
                let pronunciation = pronunciations.last
                transcription = pronunciation!["phoneticSpelling"] as! String
                return completion(transcription)
            } else {
                print(error!)
                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            }
        }).resume()
    }
}
