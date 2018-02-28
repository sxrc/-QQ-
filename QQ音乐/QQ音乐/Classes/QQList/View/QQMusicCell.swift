//
//  QQMusiacCell.swift
//  QQ音乐
//
//  Created by rc on 2017/4/24.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQMusicCell: UITableViewCell {

    var musicM: QQMusicmodel? {
        didSet {
            singerIconImageView1.image = UIImage(named: (musicM?.singerIcon)!)
            songNameLabel1.text = musicM?.name
            singerNameLabel1.text = musicM?.singer
        }
    }
    
    @IBOutlet weak var singerIconImageView1: UIImageView!
    @IBOutlet weak var songNameLabel1: UILabel!
    @IBOutlet weak var singerNameLabel1: UILabel!
    
    
    
    class func cellWithTableView(tableView: UITableView) -> QQMusicCell {
        
        let cellId = "music"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? QQMusicCell
        if cell == nil {
//            print("test")
            cell = Bundle.main.loadNibNamed("QQMusicCell", owner: nil, options: nil)?.first as? QQMusicCell
        }
        return cell!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        singerIconImageView1.layer.cornerRadius = singerIconImageView1.width * 0.5
        singerIconImageView1.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
