//
//  VoiceRecognition.swift
//  MyEnglishApp
//
//  Created by Tuan on 01/06/2021.
//

import UIKit
import Speech

class VoiceRecognition: UIViewController{
   
    
       @IBOutlet weak var tableView: UITableView!
    //Data
       var Word = [String]()
       var Pronunciation = [String]()
       var Answer = [String]()
       var QuestionChoiced = [Int]()
      
       var DataForVoice:User?
       var Text = ""
    
       
       //MARK: - Local Properties
       let audioEngine = AVAudioEngine()
       let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer()
       var request = SFSpeechAudioBufferRecognitionRequest()
       var task : SFSpeechRecognitionTask!
       var isStart : Bool = false
      
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        requestPermission()
        AddDataForVc()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(VoiceRecognition.back(sender:)))
        let image = UIImage(named: "icons8-left-52")
        newBackButton.setBackgroundImage(image, for: .normal, barMetrics: .default)

                self.navigationItem.leftBarButtonItem = newBackButton
       
        // Do any additional setup after loading the view.
    }
    
    func requestPermission(){
//
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized{

                }else if authState == .denied{
                    self.alertView(message: "Người dùng đã từ chối quyền truy cập")
                }
                else if authState == .notDetermined{
                    self.alertView(message: "Điện thoại bạn không hỗ trợ!")
                }
                else if authState == .restricted{
                    self.alertView(message: "Người dùng đã bị hạn chế sử dụng tính năng này")
                }
            }
        }
    }
    
    
    func alertView(message: String){
        let controller = UIAlertController.init(title: "Error ocured...!", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default,handler: { (_) in
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func startSpeechRecognization(){
           request = SFSpeechAudioBufferRecognitionRequest()
        

            let node = audioEngine.inputNode
            let recordingFormat = node.outputFormat(forBus: 0)
            
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            do {
                try audioEngine.start()
            } catch let error {
                alertView(message: "Error comes here for starting the audio listner =\(error.localizedDescription)")
            }
            
            guard let myRecognization = SFSpeechRecognizer() else {
                self.alertView(message: "Recognization is not allow on your local")
                return
            }
            
            if !myRecognization.isAvailable {
                self.alertView(message: "Recognization is free right now, Please try again after some time.")
            }
            
        task = speechReconizer?.recognitionTask(with: request, resultHandler: { [self] (response, error) in
                guard let response = response else {
                    if error != nil {
//                        print("")
                    }else {
//                        print("Problem in giving the response")
                    }
                    return
                }
                
                let message = response.bestTranscription.formattedString
                print("Message : \(message)")
            self.Text = message

            })
        
        }
    
    func cancelSpeechRecognization(){
      
        request = SFSpeechAudioBufferRecognitionRequest()
           task.finish()
           task.cancel()
           task = nil
           
           request.endAudio()
           audioEngine.stop()
           audioEngine.inputNode.removeTap(onBus: 0)
           
           //MARK: UPDATED
           if audioEngine.inputNode.numberOfInputs > 0 {
               audioEngine.inputNode.removeTap(onBus: 0)
           }
       
    }
    


}


extension VoiceRecognition: UITableViewDelegate,UITableViewDataSource,SamplePronuCellDelegate{
    func Check(cell: SamplePronunCell) {
        let indexPath = tableView.indexPath(for: cell)
        if self.Text == Word[indexPath!.row]{
                print("true")
                AudioService.Share.CorrectSoundEffect();                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    AudioService.Share.startSpeech(Word[indexPath!.row])
                    self.Text = ""
                    
                   }
                
                }else {
                    AudioService.Share.IncorrectSoundEffect()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                        if Text == ""
                       {
                            AudioService.Share.startSpeech("say again")
                        }else{
                            AudioService.Share.startSpeech("you said \(Text)")
                        }
                        self.Text = ""
                    }
                    
                }
        
    }
    
    
    func Speaker(cell: SamplePronunCell) {
        let indexPath = tableView.indexPath(for: cell)
        let color = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
        AudioService.Share.startSpeech(Word[indexPath!.row])
        cell.SpeakerButton.backgroundColor = .green
        cell.MicButton.isEnabled = false
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cell.SpeakerButton.backgroundColor = color
            cell.MicButton.isEnabled = true
        }
        
    }
    
    func Microphone(cell: SamplePronunCell) {
        let color = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
       
  
            startSpeechRecognization()
            cell.MicButton.isEnabled = false
            cell.SpeakerButton.isEnabled = false
            cell.MicButton.backgroundColor = .green
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                cell.MicButton.backgroundColor = color
                self.cancelSpeechRecognization()
            //ButtonColor
                cell.MicButton.isEnabled = true
                cell.SpeakerButton.isEnabled = true
          
            //Check
         
                
                }
}
    
 
    func AddDataForVc() {
       for i in 0...QuestionChoiced.count - 1{
    
           
           let answer = DataForVoice!.data[QuestionChoiced[i]].CorrectAns
           let Q = DataForVoice!.data[QuestionChoiced[i]].Question
           let pronunciation = DataForVoice!.data[QuestionChoiced[i]].Pronunciation
        
           Word.append(answer)
           Pronunciation.append(pronunciation)
           Answer.append(Q)
    
       }
       
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionChoiced.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SamplePronunCell.cellForTableView(tableView: tableView) as SamplePronunCell
        let text = Word[indexPath.row] + "  " + Pronunciation[indexPath.row]
        cell.setupCell(word:text, detail: Answer[indexPath.row])
        cell.delegate = self
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    }
 
}
