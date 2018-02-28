//
//  QQListTVC.swift
//  QQ音乐
//
//  Created by rc on 2017/4/22.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQListTVC: UITableViewController {

    var musicMs: [QQMusicmodel] = [QQMusicmodel]() {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 界面处理
        setUpInit()
        
        QQMusicDataTool.getMusicMs { (models: [QQMusicmodel]) in
            
            self.musicMs = models
            QQMusicOperationTool.shareInstance.musicMs = models
//            print(models)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = QQMusicCell.cellWithTableView(tableView: tableView)
        
        let model = musicMs[indexPath.row]
        cell.musicM = model
        
        return cell
        
    }
}

// 布局界面
extension QQListTVC {
    
    // 界面处理的总入口
    func setUpInit() -> () {
        setTableView()
    }
    
    func setTableView() -> () {
        
        let imageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundView = imageView
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = musicMs[indexPath.row]
        
        QQMusicOperationTool.shareInstance.playMusic(musicM: model)
        
        performSegue(withIdentifier: "listToDetial", sender: nil)
    }
}
