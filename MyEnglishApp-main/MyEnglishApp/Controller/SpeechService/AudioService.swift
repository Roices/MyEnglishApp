//
//  SpeechService.swift
//  myAPP
//
//  Created by Tuan on 16/05/2021.
//

import UIKit
import AVKit

class AudioService: NSObject {

   static let Share = AudioService()
    
    let speechSynthisizer = AVSpeechSynthesizer()
    func startSpeech(_ text: String){
        self.stopSpeeching()
     
       
            let utterence = AVSpeechUtterance(string: text)
            utterence.voice = AVSpeechSynthesisVoice(language: "en-gB")
            speechSynthisizer.speak(utterence)
    
    }
    
    func stopSpeeching(){
        speechSynthisizer.stopSpeaking(at: .immediate)
    }
    
    
    func CorrectSoundEffect() {
      // sound id
      var soundId: SystemSoundID = 0
      
      // nạp file vào sound id
      let bundle = Bundle.main
      let url = bundle.url(forResource: "Correct Answer.wav", withExtension: nil)
      AudioServicesCreateSystemSoundID(url! as CFURL, &soundId)
      
      // play sound id
  //    AudioServicesPlaySystemSound(soundId)
      if #available(iOS 9.0, *) {
        AudioServicesPlaySystemSoundWithCompletion(soundId) {
          // play xong, giải phóng sound id
          AudioServicesDisposeSystemSoundID(soundId)
        }
      } else {
        // Fallback on earlier versions
        AudioServicesPlaySystemSound(soundId)
      }
    }
    
 
    
    
    func IncorrectSoundEffect() {
      // sound id
      var soundId: SystemSoundID = 0
      
      // nạp file vào sound id
      let bundle = Bundle.main
      let url = bundle.url(forResource: "Incorrect.wav", withExtension: nil)
      AudioServicesCreateSystemSoundID(url! as CFURL, &soundId)
      
      // play sound id
  //    AudioServicesPlaySystemSound(soundId)
      if #available(iOS 9.0, *) {
        AudioServicesPlaySystemSoundWithCompletion(soundId) {
          // play xong, giải phóng sound id
          AudioServicesDisposeSystemSoundID(soundId)
        }
      } else {
        // Fallback on earlier versions
        AudioServicesPlaySystemSound(soundId)
      }
    }
}
