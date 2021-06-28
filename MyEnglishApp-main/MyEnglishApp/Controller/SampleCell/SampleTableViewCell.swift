//
//  SPBookingRequestDetailsTopTableViewCell.swift
//  PamperMoi
//
//  Created by Vizteck on 19/02/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit


class SampleTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageOfContent: UIImageView!
    @IBOutlet weak var LabelOfContent: UILabel!
    //    var delegate: SampleTableViewCellDelegate?
    
  
    @IBOutlet weak var View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        View.layer.cornerRadius = 10.0
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellForTableView(tableView: UITableView) -> SampleTableViewCell {
        let kSamleTableViewCellIdentifier = "kSampleTableViewCellIdentifier"
        tableView.register(UINib(nibName: "SampleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kSamleTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSamleTableViewCellIdentifier) as! SampleTableViewCell
        return cell
    }

    func setupCell(name: String) { // pass required data like this
        LabelOfContent.text = name
        ImageOfContent.image = UIImage(named: name)
    }
    

}
