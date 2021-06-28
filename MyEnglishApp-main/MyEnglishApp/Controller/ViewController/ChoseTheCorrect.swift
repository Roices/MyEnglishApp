//
//  ChoseTheCorrect.swift
//  myAPP
//
//  Created by Tuan on 14/05/2021.
//

import UIKit

class ChoseTheCorrect: UIViewController {
   
    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var ViewForWord: UIView!
    var Data2:User?
    var selectedAns : String = ""
    var questionNum = 0
    var TagTrue = ""
    var QuestionChoiced = [Int]()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        questionNum = UserDefaults.standard.integer(forKey: "NOQ")
      
        let correctAns = Data2!.data[QuestionChoiced[questionNum]].CorrectAns
        for i in 1...4{
            if Data2!.data[QuestionChoiced[questionNum]].Choice[i-1] == correctAns{
                TagTrue = "\(i)"
                print(TagTrue)
            }
            
        }
       
        //uploadToLabel
        questionNum = UserDefaults.standard.integer(forKey: "NOQ")
        WordLabel.text = Data2!.data[QuestionChoiced[questionNum]].Question
        //CustomView
        ViewForWord.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ViewForWord.layer.shadowOffset = CGSize(width: 1, height: 1)
        ViewForWord.layer.shadowOpacity = 1.0
        ViewForWord.layer.shadowRadius = 0.0
        ViewForWord.layer.masksToBounds = false
        ViewForWord.layer.cornerRadius = 10.0
        CustomButton()
        ShowQuestion()
        //Custom BackButton
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ChoseTheCorrect.back(sender:)))
        let image = UIImage(named: "icons8-left-52")
        newBackButton.setBackgroundImage(image, for: .normal, barMetrics: .default)

                self.navigationItem.leftBarButtonItem = newBackButton
        //Title
        title = "\(questionNum + 1)/\(QuestionChoiced.count)"
        
    }
    
    func CustomButton(){
        var button:UIButton=UIButton()
      
        for i in 1...4
           {
            button=view.viewWithTag(i) as!
                UIButton
            button.backgroundColor = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
           
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 10.0
        }
        
        
    }
    
    @IBAction func options(_ sender: AnyObject) {
        if sender.tag == 1
        {
            selectedAns = "1"
        }
        else if sender.tag == 2
        {
            selectedAns = "2"
        }
        else if sender.tag == 3
        {
            selectedAns = "3"
        }
        else{
            selectedAns = "4"
        }
        checkAnswer()
    }
    
//CheckAns
    
    func checkAnswer() {
        questionNum = UserDefaults.standard.integer(forKey: "NOQ")
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
       
        var button = UIButton()
        var buttonTrue = UIButton()
       
        let NumWrongQuestion = questionNum
        questionNum = questionNum + 1
        UserDefaults.standard.setValue(questionNum, forKey: "NOQ")
        
        let mapView = (self.storyboard?.instantiateViewController(identifier: "Listening"))! as Listening
        let mapViewWrong = (self.storyboard?.instantiateViewController(identifier: "WrongAnsViewController"))! as WrongAnsViewController
       //Đúng
        if selectedAns == TagTrue && questionNum <= QuestionChoiced.count - 1{
            button = view.viewWithTag(Int(selectedAns)!) as! UIButton
            button.backgroundColor = .blue
            mapView.Data3 = Data2
            AudioService.Share.CorrectSoundEffect()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               //Your code
                self.navigationController?.pushViewController(mapView, animated: true)
            }
            
//sai
        }else if selectedAns != TagTrue && NumWrongQuestion <= QuestionChoiced.count - 1{
           
//            button True
            buttonTrue = view.viewWithTag(Int(TagTrue)!) as! UIButton
            buttonTrue.backgroundColor = .blue
            
            //Button False
            button = view.viewWithTag(Int(selectedAns)!) as! UIButton
            button.backgroundColor = .red
        //delay
            AudioService.Share.IncorrectSoundEffect()
           
            mapViewWrong.NumQuestion = NumWrongQuestion
            mapViewWrong.NameViewcontroller = "toListening"
            mapViewWrong.dataFromViewController = Data2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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

//Show
    
    func ShowQuestion() {
        
      let  QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
      questionNum = UserDefaults.standard.integer(forKey: "NOQ")
            var button:UIButton=UIButton()
            for i in 1...4
            {
            button=view.viewWithTag(i) as! UIButton
                button.setTitle(Data2!.data[QuestionChoiced[questionNum]].Choice[i-1], for: .normal)
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
            print("OKOKOK")
        }))
            self.present(controller, animated: true, completion: nil)
            self.present(Cancel, animated: true, completion: nil)
            

//
    }
            
}

    
   
    
    
   


