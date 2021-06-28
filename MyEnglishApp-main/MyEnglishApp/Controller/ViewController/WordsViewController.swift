//
//  WordsViewController.swift
//  MyEnglishApp
//
//  Created by Tuan on 26/05/2021.
//

import UIKit

class WordTableViewCell: UITableViewCell {

@IBOutlet weak var WordLabel: UILabel!
@IBOutlet weak var LabelDetail: UILabel!
@IBOutlet weak var countryImageView: UIImageView!

}

class WordsViewController: UIViewController {
    
    
    @IBOutlet weak var PronunButtonView: UIView!
    @IBOutlet weak var PronunButton: UIButton!
    @IBOutlet weak var LearnButtonView: UIView!
    @IBOutlet weak var LearnButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var topic:String = ""
    var MyData:User?
    var Word = [todo]()
    var AnsWord = [String]()
    var ChoiceData = [Int]()
    var NumberQuestion = 0
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets
        
        title = "Choose 10 words"
        let ScreenWidth = UIScreen.main.bounds.width
        let ScreenHeight = UIScreen.main.bounds.height
        
       //CustomButton
        PronunButton.backgroundColor = .darkGray
        PronunButtonView.frame = CGRect(x:  ScreenWidth*0.05 , y: ScreenHeight - ScreenHeight*0.125, width: ScreenWidth*0.4, height: ScreenHeight*0.06)
        PronunButtonView.layer.cornerRadius = 10.0
        PronunButton.layer.cornerRadius = 10.0
       
    
       
        
        let x = ScreenWidth/2 + (ScreenWidth/2 - PronunButtonView.frame.width - ScreenWidth*0.05)
        LearnButton.backgroundColor = .darkGray
        LearnButtonView.frame = CGRect(x: x , y:ScreenHeight - ScreenHeight*0.125, width: ScreenWidth*0.4, height: ScreenHeight*0.065)
        LearnButtonView.layer.cornerRadius = 10.0
        LearnButton.layer.cornerRadius = 10.0
       
                
        
        
        //customBackButton
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ChoseTheCorrect.back(sender:)))
        let image = UIImage(named: "icons8-left-arrow-100")
        newBackButton.setBackgroundImage(image, for: .normal, barMetrics: .default)

                self.navigationItem.leftBarButtonItem = newBackButton
       
        parseJson(data: topic)
        AddData()
       
    }
    
    func parseJson(data:String){
        let data = data
        guard let path = Bundle.main.path(forResource: "\(data)", ofType: "json") else{
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Foundation.Data(contentsOf: url)
            MyData =  try JSONDecoder().decode(User.self, from: jsonData)
        }catch{
            print(error)
        }

    }
    
    
    func AddData(){
        let countQuestion = MyData?.data.count
        for i in 0...countQuestion! - 1{
            let answer = MyData!.data[i].CorrectAns
            let Q = MyData!.data[i].Question
            // AddWordToDataRow
            let word = todo(title: answer, isMark: false)
            Word.append(word)
            AnsWord.append(Q)
              
        }
       
    }
    
  
    //GoGame
    @IBAction func GOGame(){
        
       
        UserDefaults.standard.setValue(NumberQuestion, forKey: "NOQ")
        UserDefaults.standard.setValue(ChoiceData, forKey: "Choice")
      
        //PassData
        let mapView = (self.storyboard?.instantiateViewController(identifier: "GuessWord"))! as GuessWord
        
        mapView.DataVC1 = MyData
        self.navigationController?.pushViewController(mapView, animated: true)
       
    }
    
    
    //GoPronunciation
    @IBAction func GoPronunciation(_ sender: Any) {
        let mapView = (self.storyboard?.instantiateViewController(identifier: "VoiceRecognition"))! as VoiceRecognition
        mapView.QuestionChoiced = ChoiceData
        mapView.DataForVoice = MyData
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let mapView = (self.storyboard?.instantiateViewController(identifier: "HomeViewController"))! as HomeViewController
            self.navigationController?.pushViewController(mapView, animated: true)
    }
    
}

extension WordsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (MyData?.data.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell",for: indexPath) as! WordTableViewCell
        let text =  Word[indexPath.row]
        let textDetail = AnsWord[indexPath.row]
        cell.WordLabel.text = "\(indexPath.row + 1). "+text.title
        cell.LabelDetail.text = textDetail
        cell.countryImageView.image = text.isMark == true ? UIImage(named: "Checkmark"):UIImage(named: "Mark")
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let Position = indexPath.row
        var todo = Word[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) as? WordTableViewCell else {return}
        todo.isMark = !todo.isMark
        Word.remove(at: indexPath.row)
        Word.insert(todo, at: indexPath.row)
       
        if todo.isMark == true{
            ChoiceData.append(Position)
        }else{
            if let index = ChoiceData.firstIndex(of: Position) {
              ChoiceData.remove(at: index)
            }
        }
        
        cell.countryImageView.image = todo.isMark == true ? UIImage(named: "Checkmark"):UIImage(named: "Mark")

        if (ChoiceData.count > 9){
            let colorPronunBut = UIColor(hexString: "E06C2D")
            let colorLearnBut = UIColor(hexString: "69248D")
            LearnButton.backgroundColor = colorLearnBut
            LearnButton.isEnabled = true
           
            PronunButton.backgroundColor = colorPronunBut
            PronunButton.isEnabled = true
        }else{
            LearnButton.isEnabled = false
            PronunButton.isEnabled = false
            PronunButton.backgroundColor = .darkGray
            LearnButton.backgroundColor = .darkGray
        }

       }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


struct todo {
   var title:String
    var isMark:Bool
}
