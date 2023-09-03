//
//  ViewController.swift
//  Project5
//
//  Created by Adarsh Singh on 07/08/23.
//

import UIKit
class ViewController: UITableViewController {

    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
        if let startWordsUrl = Bundle.main.path(forResource: "start", ofType: "txt"){
            if let startWord = try? String(contentsOfFile: startWordsUrl){
                allWords = startWord.components(separatedBy: "\n")
            }
            
        }else{
            allWords = ["silkworm"]
        }
        startGame()
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    @objc
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc
    func addTapped(){
        
        let ac = UIAlertController(title: "", message: "Be Meaningful", preferredStyle: .alert)
        
        ac.addTextField{(Selftextfield) in
            Selftextfield.placeholder = "Add Word"
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text?.lowercased() else{ return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        var errorTtile: String
        var errorMess: String

            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(answer, at: 0)

                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        
                        return
                    }else{
                        errorTtile = "Kuch Bhi"
                        errorMess = "Anpadh saale 🤓"
                    }
                }else{
                    errorTtile = "Hogaya Use Pehle"
                    errorMess = "Dekh jaldi 🥸"
                }
            }else{
                errorTtile = "Galat"
                errorMess = "Usme vo letter hi nahi hai 😝"
            }
        alertDo(errorMess: errorMess, errorTitle: errorTtile)
    }
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        for letter in word{
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    func alertDo(errorMess:String, errorTitle: String){
        let ac = UIAlertController(title: errorTitle, message: errorMess, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        if word.count >= 3{
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return mispelledRange.location == NSNotFound
        }else{
            return false
        }
    }
    
    


}


