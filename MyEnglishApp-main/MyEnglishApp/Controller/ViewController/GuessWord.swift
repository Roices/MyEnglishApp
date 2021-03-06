//
//  GuessWord.swift
//  myAPP
//
//  Created by Tuan on 14/05/2021.
//

import UIKit

class GuessWord:UIViewController {

    
    @IBOutlet weak var ViewForWord: UIView!
    var Answer = ""
    var wordButtons: [UIButton] = []
    var selectionButtons: [UIButton] = []
    var word: String = ""
    var charIndex = 0
    var numberOfQuestion = 0
    var QuestionChoiced = [Int]()
    var DataVC1:User?
    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var WordLabel: UILabel!
    
    override func viewDidLoad() {
      super.viewDidLoad()
    
       
       
      //CustomViewforWord
        ViewForWord.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ViewForWord.layer.shadowOffset = CGSize(width: 1, height: 1)
        ViewForWord.layer.shadowOpacity = 1.0
        ViewForWord.layer.shadowRadius = 0.0
        ViewForWord.layer.masksToBounds = false
        ViewForWord.layer.cornerRadius = 10.0
       
      //Custom CheckButton
//        button.backgroundColor = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
       
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 10.0
        
       //AddData
       
        changeWord()
        
        //CustomBackButton
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(GuessWord.back(sender:)))
        let image = UIImage(named: "icons8-left-52")
        newBackButton.setBackgroundImage(image, for: .normal, barMetrics: .default)

                self.navigationItem.leftBarButtonItem = newBackButton
        //ShowAnswer
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        let numQuestion = UserDefaults.standard.integer(forKey: "NOQ")
        WordLabel.text = DataVC1!.data[QuestionChoiced[numQuestion]].Question
        title = "\(numQuestion + 1)/\(QuestionChoiced.count)"
        
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    func updateWord(newWord: String) {
      let kButtonHorizonSpace: CGFloat = 4.0
      let kButtonVerticalSpace: CGFloat = 4.0
      
      word = newWord.uppercased()
      charIndex = 0
      
      // remove buttons
      for b in wordButtons {
        b.removeFromSuperview()
      }
      wordButtons = []
      
      for b in selectionButtons {
        b.removeFromSuperview()
      }
      selectionButtons = []
      
      // t???o m???i buttons
      let size = (self.view.bounds.size.width - 6 * kButtonHorizonSpace) / 7
      let buttonSize = CGSize(width: size, height: size)
        var buttonPoint = CGPoint(x: 0, y: self.view.bounds.size.height / 2 - self.view.bounds.size.height/50)
      
      // t??ch word th??nh c??c d??ng <= 7 k?? t???
      var lines = [[String]]()
      for c in word {
        if let count = lines.last?.count,
          count < 7 {
          lines[lines.count - 1].append(String(c))
        } else {
          lines.append([String(c)])
        }
      }
      
      // t???o word button
      for line in lines {
        let lineWidth = buttonSize.width * CGFloat(line.count) + CGFloat(line.count - 1) * kButtonHorizonSpace
        buttonPoint.x = (view.bounds.size.width - lineWidth) / 2
        
        // t???o button trong line
        for _ in line {
          // t???o button
          let b = UIButton(type: .custom)
          b.frame = CGRect(origin: buttonPoint, size: buttonSize)
  //        b.setTitle(c, for: .normal)
          b.setTitle("", for: .normal)
          b.backgroundColor = .red
          b.layer.cornerRadius = 4
          b.addTarget(self, action: #selector(wordButtonTouchUpInside(sender:)), for: .touchUpInside)
          
          // add v??o view + array
          wordButtons.append(b)
          view.addSubview(b)
          
          // chu???n b??? button point cho button ti???p theo
          buttonPoint.x += buttonSize.width + kButtonHorizonSpace
        }
        
        // xu???ng d??ng, chu???n b??? button point cho d??ng ti???p theo
        buttonPoint.y += buttonSize.height + kButtonVerticalSpace
      }
      
      // t???o lines cho selection
      // b??? xung cho ????? 2 d??ng
      if lines.count < 2 {
        lines.append([])
      }
      
      // b??? xung m???i d??ng ????? 7 k?? t???
      for i in 0..<lines.count {
        if lines[i].count < 7 {
          for _ in 0..<7 - lines[i].count {
            let random = arc4random() % 26
            let aCode = ("A".unicodeScalars.first?.value)!
            let cCode = aCode + random
            let c = Character(UnicodeScalar(cCode)!)
            lines[i].append(String(c))
          }
        }
      }
      
      // tr???n lines
      for i in 0..<lines.count {
        for j in 0..<lines[i].count {
          // t??m v??? tr?? ng???u nhi??n
          let i1 = Int(arc4random() % UInt32(lines.count))
          let j1 = Int(arc4random() % UInt32(lines[i1].count))
          
          // ?????i ch???
          let t = lines[i][j]
          lines[i][j] = lines[i1][j1]
          lines[i1][j1] = t
        }
      }
      
      // t???o button cho selection
      for line in lines {
        let lineWidth = buttonSize.width * CGFloat(line.count) + CGFloat(line.count - 1) * kButtonHorizonSpace
        buttonPoint.x = (view.bounds.size.width - lineWidth) / 2
        
        // t???o button trong line
        for c in line {
          // t???o button
          let b = UIButton(type: .custom)
          b.frame = CGRect(origin: buttonPoint, size: buttonSize)
          b.setTitle(c, for: .normal)
          b.setTitleColor(.red, for: .normal)
          b.backgroundColor = .white
          b.layer.cornerRadius = 4
          b.layer.borderColor = UIColor.black.cgColor
          b.layer.borderWidth = 1
          b.addTarget(self, action: #selector(selectionButtonTouchUpInside(sender:)), for: .touchUpInside)
          
          // add v??o view + array
          selectionButtons.append(b)
          view.addSubview(b)
          
          // chu???n b??? button point cho button ti???p theo
          buttonPoint.x += buttonSize.width + kButtonHorizonSpace
        }
        
        // xu???ng d??ng, chu???n b??? button point cho d??ng ti???p theo
        buttonPoint.y += buttonSize.height + kButtonVerticalSpace
      }
    }

   
    //ChangeWord
     func changeWord() {
     
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        numberOfQuestion = UserDefaults.standard.integer(forKey: "NOQ")
        let text = DataVC1!.data[QuestionChoiced[numberOfQuestion]].CorrectAns
        updateWord(newWord: text)
        print(text)
     }
    
  
    
      @objc func wordButtonTouchUpInside(sender: UIButton) {
      // x??a
      sender.setTitle("", for: .normal)
      
      // ?????t charIndex
        charIndex = wordButtons.firstIndex(of: sender)!
    }
    
      @objc func selectionButtonTouchUpInside(sender: UIButton) {
      // l???y k?? t??? ???????c ch???n
      let c = sender.title(for: .normal)
      
      // ?????y v??o word
      wordButtons[charIndex].setTitle(c, for: .normal)
      
      // ki???m tra ???? k???t th??c ch??a
      var fillAll = true
      for b in wordButtons {
        if (b.title(for: .normal)?.count)! < 1 {
          fillAll = false
          break
        }
      }
      
      if fillAll {
        // ki???m tra t???
        // l???y selected word
        var selectedWord = ""
        for b in wordButtons {
          selectedWord += b.title(for: .normal)!
        }
        Answer = selectedWord
        // check
      if selectedWord == word {
           print("True")
        }
      } else {
        // ch??a k???t th??c, ?????t charIndex v??o v??? tr?? ?????u ti??n c??n tr???ng
        for i in 0..<wordButtons.count {
          if wordButtons[i].title(for: .normal)!.count == 0 {
            charIndex = i
            break
          }
        }
      }
    }
    
    //CheckAns
    @IBAction  func ChooseButton(_ sender: Any) {
        numberOfQuestion = UserDefaults.standard.integer(forKey: "NOQ")
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        
        let mapView = (self.storyboard?.instantiateViewController(identifier: "ChoseTheCorrect"))! as ChoseTheCorrect
        let mapViewWrong = (self.storyboard?.instantiateViewController(identifier: "WrongAnsViewController"))! as WrongAnsViewController
        
        //SaveNumberOfQuestion
        let NumWrongQuestion = numberOfQuestion
        numberOfQuestion = numberOfQuestion + 1
        UserDefaults.standard.setValue(numberOfQuestion, forKey: "NOQ")
        //????ng
        if Answer == word && numberOfQuestion <= QuestionChoiced.count - 1 {

            AudioService.Share.CorrectSoundEffect()
            mapView.Data2 = DataVC1
            self.navigationController?.pushViewController(mapView, animated: true)
            
//Sai
        }else if Answer != word && NumWrongQuestion <= QuestionChoiced.count-1{
            
            AudioService.Share.IncorrectSoundEffect()
            mapViewWrong.NumQuestion = NumWrongQuestion
            mapViewWrong.dataFromViewController = DataVC1
            mapViewWrong.NameViewcontroller = "toChoseTheCorrect"
            self.navigationController?.pushViewController(mapViewWrong, animated: true)
        } //H???t s??? c??u
        else{
            
          let mapView = (self.storyboard?.instantiateViewController(identifier: "WordsViewController"))! as WordsViewController
          let controller = UIAlertController.init(title: "", message: "B???n ???? ho??n th??nh \(QuestionChoiced.count) t???!!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default,handler: { (_) in
            self.navigationController?.pushViewController(mapView, animated: true)
            }))
            self.present(controller, animated: true, completion: nil)
    }
    
}
    
}

extension GuessWord{
     

//    //BackButtonAction
    @objc func back(sender: UIBarButtonItem) {
        
        let mapView = (self.storyboard?.instantiateViewController(identifier: "WordsViewController"))! as WordsViewController
        let controller = UIAlertController.init(title: "", message: "B???n mu???n tho??t game?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default,handler: { (_) in
            self.navigationController?.pushViewController(mapView, animated: true)
            }))

        let Cancel = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Kh??ng!",style: .cancel,handler: { (_) in
        }))
            self.present(controller, animated: true, completion: nil)
            self.present(Cancel, animated: true, completion: nil)
            


    }
}
