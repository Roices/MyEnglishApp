//
//  WrongAnsViewController.swift
//  myAPP
//
//  Created by Tuan on 17/05/2021.
//

import UIKit

class WrongAnsViewController: UIViewController {
//cmt
    @IBOutlet weak var Word: UILabel!
    @IBOutlet weak var Meaning: UILabel!
    
    @IBOutlet weak var ViewForWord: UIView!
    @IBOutlet weak var CheckButton: UIButton!
    
    var NameViewcontroller = ""
    var dataFromViewController:User?
    var NumQuestion = 0
    var QuestionChoiced = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "REMEMBER"
      //ViewCustom
        ViewForWord.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ViewForWord.layer.shadowOffset = CGSize(width: 1, height: 1)
        ViewForWord.layer.shadowOpacity = 1.0
        ViewForWord.layer.shadowRadius = 0.0
        ViewForWord.layer.masksToBounds = false
        ViewForWord.layer.cornerRadius = 10.0
        
       //CustomBackButton
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(WrongAnsViewController.back(sender:)))
        let image = UIImage(named: "icons8-left-52")
        newBackButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
                self.navigationItem.leftBarButtonItem = newBackButton
        
        //CustomCheckButton
        CheckButton.layer.cornerRadius = CheckButton.bounds.size.height/2;
        
        
       
        //PassWord->Label
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        Word.text = dataFromViewController?.data[QuestionChoiced[NumQuestion]].CorrectAns
        Meaning.text = dataFromViewController!.data[QuestionChoiced[NumQuestion]].Question
        }

        // Do any additional setup after loading the view
    @IBAction func NextQuestion(){
        performSegue(withIdentifier: NameViewcontroller, sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        NumQuestion = UserDefaults.standard.integer(forKey: "NOQ")
        QuestionChoiced = UserDefaults.standard.array(forKey: "Choice") as! [Int]
        if segue.identifier == "toChoseTheCorrect" && NumQuestion < QuestionChoiced.count - 1{
            let vc = segue.destination as! ChoseTheCorrect
            vc.Data2 = dataFromViewController
           
        } else if segue.identifier == "toListening" && NumQuestion < QuestionChoiced.count - 1{
            let vc = segue.destination as! Listening
            vc.Data3 = dataFromViewController
           
        } else if segue.identifier == "toGuessWord" && NumQuestion < QuestionChoiced.count - 1{
            let vc = segue.destination as! GuessWord
            vc.DataVC1 = dataFromViewController
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
            print("OKOKOK")
        }))
            self.present(controller, animated: true, completion: nil)
            self.present(Cancel, animated: true, completion: nil)
            

//
    }



}
