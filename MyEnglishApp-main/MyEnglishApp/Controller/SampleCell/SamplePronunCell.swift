//
//  SamplePronunCell.swift
//  MyEnglishApp
//
//  Created by Tuan on 02/06/2021.
//

//
//  SPBookingRequestDetailsTopTableViewCell.swift
//  PamperMoi
//
//  Created by Vizteck on 19/02/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

protocol SamplePronuCellDelegate{
    func Speaker(cell:SamplePronunCell)
   func Microphone(cell:SamplePronunCell)
    func Check(cell:SamplePronunCell)
}

class SamplePronunCell: UITableViewCell {

    var delegate:SamplePronuCellDelegate?
    
    @IBOutlet weak var ViewCell: UIView!
    
    @IBOutlet weak var Word: UILabel!
    @IBOutlet weak var WordDetail: UILabel!
    //
    @IBOutlet weak var SpeakerButton: UIButton!
    @IBOutlet weak var MicButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    

//
    override func awakeFromNib() {
        super.awakeFromNib()
        customButton()
        ViewCell.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //Custom 2 Button
    func customButton(){
        let color = UIColor.init(red: 0, green: 0.75, blue: 0.94, alpha: 9.0)
        SpeakerButton.layer.cornerRadius = SpeakerButton.bounds.size.height/2;
        SpeakerButton.backgroundColor = color
//        SpeakerButton.layer.masksToBounds = false
        
        MicButton.layer.cornerRadius = MicButton.bounds.size.height/2;
        MicButton.backgroundColor = color
//        MicButton.layer.masksToBounds = false
        
        CheckButton.backgroundColor = color
        CheckButton.layer.cornerRadius = CheckButton.bounds.size.height/2;
        

    }
    class func cellForTableView(tableView: UITableView) -> SamplePronunCell {
        let kSamleTableViewCellIdentifier = "kSampleTableViewCellIdentifier"
        tableView.register(UINib(nibName: "SamplePronunCell", bundle: Bundle.main), forCellReuseIdentifier: kSamleTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSamleTableViewCellIdentifier) as! SamplePronunCell
        return cell
    }

    func setupCell(word: String, detail:String) { // pass required data like this
        Word.text = word
        WordDetail.text = detail
    }

 
    
    @IBAction func CheckingButton(){
        delegate?.Check(cell: self)
    }
    
   @IBAction func SpeakerUsing() {
        delegate?.Speaker(cell: self)
      
    }

    @IBAction func MicUsing() {
        delegate?.Microphone(cell: self)
    }

}

