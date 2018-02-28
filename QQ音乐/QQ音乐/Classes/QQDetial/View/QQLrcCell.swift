//
//  QQLrcCell.swift
//  QQ音乐
//
//  Created by rc on 2017/5/5.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var progress: CGFloat = 0.0 {
        didSet {
            lrcLabel.radio = progress
        }
    }
    
    
    var lrcContent: String = "" {
        didSet {
            lrcLabel.text = lrcContent
        }
    }
    
    class func cellWithTableView(tableView: UITableView) -> QQLrcCell {
        
        let cellID = "lrc"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQLrcCell
        
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("QQLrcCell", owner: nil, options: nil)?.first as? QQLrcCell
        }
        
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
