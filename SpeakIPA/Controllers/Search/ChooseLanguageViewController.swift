//
//  ChooseLanguageViewController.swift
//  SpeakIPA
//
//  Created by nguyen thy on 11/3/20.
//

import UIKit

class ChooseLanguageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    // TODO: Create a database on Firebase for all languages
    let languages = [
        Language(name:"British English", code:"EN-GB") ,
        Language(name:"American English", code:"EN-US"),
        Language(name:"French", code:"french"),
        Language(name:"Southern Vietnamese", code:"vietnamese_south"),
        Language(name:"Japanese", code:"japanese"),
        Language(name:"Finnish", code:"finnish"),
        Language(name:"Spanish", code:"spanish")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // TODO: Retrieve all languages

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let language = languages[indexPath.row]
        let name = language.name!
        cell.languageLabel.text = name
        cell.layer.cornerRadius = 16
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-90) / 2
        let height = CGFloat(100)
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: segues.toTranscribeWord, sender: collectionView.cellForItem(at: indexPath))
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(named: "AppYellow")
    }
    
    
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
        let language = languages[indexPath!.row]
        let vc = segue.destination as! SearchViewController
        vc.language = language
    }
    

}
