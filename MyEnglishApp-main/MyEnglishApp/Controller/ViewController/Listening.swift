//
//  Listening.swift
//  myAPP
//
//  Created by Tuan on 14/05/2021.
//

import UIKit

class Listening: UIViewController {

    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var ViewForWord: UIView!
    @IBOutlet weak var WordLabel: UILabel!
    
    var selectedAns:String = ""
    var Data3:User?
    var questionNum : Int = 0
    var QuestionChoiced = [Int]()
    var TagTrue = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //GetTagTrue
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        questionNum = UserDefaults.standard.integer(forKey: "NOQ")
        let correctAns = Data3!.data[QuestionChoiced[questionNum]].CorrectAns
        for i in 1...4{
            if Data3!.data[QuestionChoiced[questionNum]].Choice[i-1] == correctAns{
                TagTrue = "\(i)"
            }
        }
        title = "\(questionNum + 1)/\(QuestionChoiced.count)"
        //CustomView
        ViewForWord.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ViewForWord.layer.shadowOffset = CGSize(width: 1, height: 1)
        ViewForWord.layer.shadowOpacity = 1.0
        ViewForWord.layer.shadowRadius = 0.0
        ViewForWord.layer.masksToBounds = false
        ViewForWord.layer.cornerRadius = 10.0
        //CUstombutton

        CustomButton()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Listening.back(sender:)))
        let image = UIImage(named: "icons8-left-52")
        newBackButton.setBackgroundImage(image, for: .normal, barMetrics: .default)

        self.navigationItem.leftBarButtonItem = newBackButton
        //UploadToLabel
        let numQuestion = UserDefaults.standard.integer(forKey: "NOQ")
        WordLabel.text = Data3!.data[QuestionChoiced[numQuestion]].Question
       
    }
    
    @IBAction func options(_ sender: AnyObject) {
        questionNum = UserDefaults.standard.integer(forKey: "NOQ")
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        
        if sender.tag == 1
        {
            selectedAns = "1"
            AudioService.Share.startSpeech(Data3!.data[QuestionChoiced[questionNum]].Choice[0])
          
            
        }
        else if sender.tag == 2
        {
            selectedAns = "2"
            AudioService.Share.startSpeech(Data3!.data[QuestionChoiced[questionNum]].Choice[1])
        }
        else if sender.tag == 3
        {
            selectedAns = "3"
            AudioService.Share.startSpeech(Data3!.data[QuestionChoiced[questionNum]].Choice[2])
            
        }
        else{
            selectedAns = "4"
            AudioService.Share.startSpeech(Data3!.data[QuestionChoiced[questionNum]].Choice[3])
            
        }
        chooseAnswer()
    }
    
    func CustomButton(){
        var button:UIButton=UIButton()
        var space:CGFloat = 0.0
 // choices
        for i in 1...4
        {
            button=view.viewWithTag(i) as!
                UIButton
            button.backgroundColor = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
            button.frame.origin.x = UIScreen.main.bounds.width/2 - button.frame.height/2
            button.frame.origin.y = UIScreen.main.bounds.height/2 - UIScreen.main.bounds.height/20 + space
            
            button.layer.cornerRadius = button.bounds.size.height/2;
            space += UIScreen.main.bounds.height/9.5
           
            
        }
        //buttonCheck
       
//       CheckButton.backgroundColor = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
        CheckButton.backgroundColor = .gray
        CheckButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        CheckButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        CheckButton.layer.shadowOpacity = 1.0
        CheckButton.layer.shadowRadius = 0.0
        CheckButton.layer.masksToBounds = false
        CheckButton.layer.cornerRadius = 4.0
        CheckButton.isEnabled = false
        

    }

    //khi TouchButton
    func chooseAnswer() {
        var button = UIButton()
        let color:UIColor = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
        button =  view.viewWithTag(Int(selectedAns)!) as! UIButton
        
        if button.tag == Int(selectedAns)
         {
          button.backgroundColor = .white
          button = view.viewWithTag(Int(selectedAns)!) as! UIButton
          CheckButton.setTitle("Chọn", for: .normal)
          CheckButton.backgroundColor = .green
          CheckButton.isEnabled = true
            for i in 1...4{
                if i != Int(selectedAns){
                    button = view.viewWithTag(i) as! UIButton
                    button.backgroundColor = color
                }
            }
        }
    }

    
    
//checkAns
    @IBAction func CheckAns(){
    
        questionNum = UserDefaults.standard.integer(forKey: "NOQ")
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        let NumWrongQuestion = questionNum

       
        //lấy VC1-VCWrong
        let mapView = (self.storyboard?.instantiateViewController(identifier: "GuessWord"))! as GuessWord
        let mapViewWrong = (self.storyboard?.instantiateViewController(identifier: "WrongAnsViewController"))! as WrongAnsViewController
        
        //lấy ButtonCorrect
        var button = UIButton()
        var buttonTrue = UIButton()
       
        questionNum = questionNum + 1
        UserDefaults.standard.setValue(questionNum, forKey: "NOQ")
        
        //CheckCorrect
        if selectedAns == TagTrue && questionNum <= QuestionChoiced.count - 1{
            button = view.viewWithTag(Int(selectedAns)!) as! UIButton
            button.backgroundColor = .blue
            AudioService.Share.CorrectSoundEffect()
           
            mapView.DataVC1 = Data3
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
           //Your code
            self.navigationController?.pushViewController(mapView, animated: true)
        }
    //nếu sai
        }else if selectedAns != TagTrue && NumWrongQuestion <= QuestionChoiced.count{
            AudioService.Share.IncorrectSoundEffect()
           
//            button True
            buttonTrue = view.viewWithTag(Int(TagTrue)!) as! UIButton
            buttonTrue.backgroundColor = .blue
            //Button False
            button = view.viewWithTag(Int(selectedAns)!) as! UIButton
            button.backgroundColor = .red
            
            
            mapViewWrong.NumQuestion = NumWrongQuestion
            mapViewWrong.NameViewcontroller = "toGuessWord"
            mapViewWrong.dataFromViewController = Data3
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               //Your code
                self.navigationController?.pushViewController(mapViewWrong, animated: true)
            }
            
        }else{
            let mapView = (self.storyboard?.instantiateViewController(identifier: "WordsViewController"))! as WordsViewController
            let controller = UIAlertController.init(title: "", message: "Bạn đã hoàn thành \(QuestionChoiced.count) từ!!", preferredStyle: .alert)
          controller.addAction(UIAlertAction(title: "OK",style: .default,handler: { (_) in
              self.navigationController?.pushViewController(mapView, animated: true)
              }))
              self.present(controller, animated: true, completion: nil)
        }
        
        
    }

    
    @objc func back(sender: UIBarButtonItem) {
            let mapView = (self.storyboard?.instantiateViewController(identifier: "WordsViewController"))! as WordsViewController
            let controller = UIAlertController.init(title: "", message: "Bạn muốn thoát game?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default,handler: { (_) in
            self.navigationController?.pushViewController(mapView, animated: true)
            }))
        
            let Cancel = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Không!",style: .cancel,handler: { (_) in
            
        }))
            self.present(controller, animated: true, completion: nil)
            self.present(Cancel, animated: true, completion: nil)
            

//
    }


}
