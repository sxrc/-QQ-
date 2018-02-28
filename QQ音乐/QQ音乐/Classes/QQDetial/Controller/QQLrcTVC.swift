//
//  QQLrcTVC.swift
//  QQ音乐
//
//  Created by rc on 2017/5/4.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQLrcTVC: UITableViewController {

    // 提供给外界赋值的进度
    var progress: CGFloat = 0.0 {
        didSet {
            let indexPath = NSIndexPath(row: scrollRow, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as? QQLrcCell
            
            cell?.progress = progress
            
        }
    }
    
    
    // 提供给外界的数值，代表需要滚动的行数
    var indexPath0: IndexPath?
    var indexPath1: IndexPath?
    var currentIndexPath: Int?
    var scrollRow = 0 {
        didSet {
//            print(scrollRow)
            // 更新太频繁，导致滚动不能实现
            if scrollRow == oldValue {
                return
            }
            
            // 先刷新再滚动
            let indexPaths = tableView.indexPathsForVisibleRows
            tableView.reloadRows(at: indexPaths!, with: .fade)
            
            indexPath0 = NSIndexPath(row: scrollRow, section: 0) as IndexPath
//            let row0: Int = (indexPath0?.last)! + 1
//            
//            indexPath1 = (NSIndexPath(row: row0, section: 0) as IndexPath)
//            print(indexPath0?[1] as Any, indexPath1?[1] as Any)
//            currentIndexPath = indexPath0?.last
//            tableView.reloadRows(at: [indexPath0!, indexPath1!], with: UITableViewRowAnimation.none)
//            
            tableView.scrollToRow(at: indexPath0!, at: .middle, animated: true)
        }
    }
    
    var lrcMs: [QQLrcModel] = [QQLrcModel]() {
        didSet {
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        view.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsetsMake(view.size.height * 0.5, 0, view.size.height * 0.5, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lrcMs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = QQLrcCell.cellWithTableView(tableView: tableView)
        let model = lrcMs[indexPath.row]
        
        
        if indexPath.row == scrollRow {
            cell.progress = progress
        } else {
            cell.progress = 0
        }
        cell.lrcContent = model.lrcContent
//        if currentIndexPath == indexPath.last {
//            cell.lrcLabel.font = UIFont.systemFont(ofSize: 17)
//        } else {
//            cell.lrcLabel.font = UIFont.systemFont(ofSize: 15)
//        }
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
