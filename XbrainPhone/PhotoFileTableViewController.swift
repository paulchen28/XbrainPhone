//
//  PhotoFileTableViewController.swift
//  XbrainPhone
//
//  Created by 陳家騏 on 2021/12/24.
//

import UIKit
import SQLite3

//定義單筆學生資料的結構
struct CameraFile
{
    var number = 0
    var date = ""
    var picture:Data?
    var remark = ""
}

class PhotoFileTableViewController: UITableViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    /*
    //宣告資料庫連線指標
    var db:OpaquePointer?
    //紀錄單一資料行
    var structRow = CameraFile()
    //宣告學生陣列，存放從資料庫查詢到的資料（此陣列即『離線資料集』）
    var arrTable = [CameraFile]()
    
    //MARK: - 自定函式
    //查詢資料庫，存放到離線資料集
    func getDataFromTable()
    {
        //先清空陣列
        arrTable.removeAll()
        //準備查詢用的SQL指令
        let sql = "select no,name,gender,picture,phone,address,email,myclass from student order by no"
        //將SQL指令轉換成C語言的字元陣列
        let cSql = sql.cString(using: .utf8)!
        //宣告儲存查詢結果的指標
        var statement:OpaquePointer?
        //準備查詢（第三個參數若為正數則限定SQL指令的長度，若為負數則不限SQL指令的長度。第四個和第六個參數為預留參數，目前沒有作用。）
        if sqlite3_prepare_v3(db, cSql, -1, 0, &statement, nil) == SQLITE_OK
        {
            print("資料庫查詢指令執行成功！")
            //往下讀取『連線資料集』(statement)中的一筆資料
            while sqlite3_step(statement) == SQLITE_ROW
            {
                //讀取當筆資料的每一欄
                let number = sqlite3_column_text(statement!, 0)!
                let strNumber = String(cString: number)
                structRow.number = strNumber
                
                let name = sqlite3_column_text(statement!, 1)!
                let strDate = String(cString: name)
                structRow.date = strDate
                
//                print("學號：\(strNo)，姓名：\(strName)")
                
                let gender = Int(sqlite3_column_int(statement!, 2))
                structRow.gender = gender
                
                //準備當筆的圖檔資料
                var imgData:Data!
                //如果有讀取到檔案的位元資料
                if let totalBytes = sqlite3_column_blob(statement!, 3)
                {
                    //讀取檔案長度
                    let fileLength = Int(sqlite3_column_bytes(statement!, 3))
                    //將檔案的位元資料和檔案長度初始化成為Data
                    imgData = Data(bytes: totalBytes, count: fileLength)
                }
                else    //當照片欄位為NULL
                {
                    //以預設大頭照來產生Data
                    imgData = UIImage(named: "default")!.jpegData(compressionQuality: 0.8)
                }
                //將大頭照的Data存入結構成員
                structRow.picture = imgData
                
                let phone = sqlite3_column_text(statement!, 4)!
                let strPhone = String(cString: phone)
                structRow.phone = strPhone
                
                let address = sqlite3_column_text(statement!, 5)!
                let strAddress = String(cString: address)
                structRow.address = strAddress
                
                let email = sqlite3_column_text(statement!, 6)!
                let strEmail = String(cString: email)
                structRow.email = strEmail
                
                let myclass = sqlite3_column_text(statement!, 7)!
                let strClass = String(cString: myclass)
                structRow.myclass = strClass
                //將整筆資料加入陣列
                arrTable.append(structRow)
            }
            //如果有取得資料
            if statement != nil
            {
                //則關閉SQL連線資料集
                sqlite3_finalize(statement!)
            }
        }
        
        DispatchQueue.main.async {
            //重整表格資料
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Target Action
    //導覽列的編輯按鈕
    @objc func buttonEditAction(_ sender:UIBarButtonItem)
    {
//        print("編輯按鈕被按下！")
        if self.tableView.isEditing //如果表格在編輯狀態
        {
            //讓表格取消編輯狀態
            self.tableView.isEditing = false
            //更改按鈕文字
            self.navigationItem.leftBarButtonItem?.title = "編輯"
        }
        else    //如果表格不在編輯狀態
        {
            //讓表格進入編輯狀態
            self.tableView.isEditing = true
            //更改按鈕文字
            self.navigationItem.leftBarButtonItem?.title = "取消"
        }
    }
    
    /*
    //導覽列的新增按鈕
    @objc func buttonAddAction(_ sender:UIBarButtonItem)
    {
        if let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
        {
            addVC.myTableVC = self
            
            self.show(addVC, sender: nil)
        }
    }
     */
    
    //由下拉更新元件呼叫的觸發事件
    @objc func handleRefresh()
    {
        //Step1.重新讀取實際的資料庫資料，並且填入離線資料集（arrTable）
        getDataFromTable()
        
        //Step2.執行表格資料更新（重新執行tableview datasource三個事件）
        self.tableView.reloadData()
        
        //Step3.停止下拉的動畫特效
        self.tableView.refreshControl?.endRefreshing()
        
    }
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //取得資料庫連線
        db = (UIApplication.shared.delegate as! AppDelegate).getDB()
        //取得global佇列
        let global = DispatchQueue.global()
        global.async {
            //執行資料庫查詢
            self.getDataFromTable()
        }
        
        /*
        //在導覽列的左右側增加按鈕
        let strEdit = NSLocalizedString("Edit", tableName: "InfoPlist", bundle: Bundle.main, value: "", comment: "")
        let strAddNew = NSLocalizedString("AddNew", tableName: "InfoPlist", bundle: Bundle.main, value: "", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: strEdit, style: .plain, target: self, action: #selector(buttonEditAction(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: strAddNew, style: .plain, target: self, action: #selector(buttonAddAction(_:)))
        */
        
        //設定導覽列的背景色
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "title"), for: .default)       //PS.此語法在iOS15失效！
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemCyan
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        //準備下拉更新元件
        self.tableView.refreshControl = UIRefreshControl()
        //當下拉更新元件出現時（觸發valueChanged事件），綁定執行事件
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //提供下拉更新元件的提示文字
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
    }
    
    // MARK: - Table view data source
    //表格有幾段
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        //表格只有一段
        return 1
    }
    //每一段表格有幾列
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        print("詢問第\(section)段表格有幾列")
//        if section == 0
//        {
//            return 3
//        }
//        else if section == 1
//        {
//            return 1
//        }
//        return 0
        //以陣列個數作為表格的列數
        return arrTable.count
    }
    
    //提供每一段每一列的儲存格樣式
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("詢問第\(indexPath.section)段,第\(indexPath.row)列的儲存格")
        //注意：使用自訂儲存格，必須完成自訂儲存格類別的轉型
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        //<方法一>取大頭照的四邊圓角為圖片的一半寬度，即形成圓形圖片 PS.<方法二>在MyCell類別
//        cell.imgPicture.layer.cornerRadius = cell.imgPicture.bounds.width / 2
        cell.imgPicture.image = UIImage(data: arrTable[indexPath.row].picture!)
        cell.lblNo.text = arrTable[indexPath.row].no
        cell.lblName.text = arrTable[indexPath.row].name
        if arrTable[indexPath.row].gender == 0
        {
            cell.lblGender.text = "女"
        }
        else
        {
            cell.lblGender.text = "男"
        }
        return cell
    }
    
    
    
    //MARK: - Table View Delegate
    //回傳儲存格高度
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 120
//    }
    
    
    //<方法一>哪一個儲存格被點選
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("『\(arrTable[indexPath.row].name)』被點選")
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    //================================儲存格刪除相關作業（7-9新版）==========================================
    //以下事件會取代7-5舊版的刪除事件
    //儲存格向左滑動事件
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        //準備『更多』按鈕
        let goAction = UIContextualAction(style: .normal, title: "更多") { action, view, completionHadler in
            //按鈕按下去要做的事情
//            completionHadler(true)
            print("更多按鈕被按下！！！")
        }
        //設定更多按鈕的背景色
        goAction.backgroundColor = .blue
        //準備『刪除』按鈕
        let delAction = UIContextualAction(style: .destructive, title: "刪除") { action, view, completionHanler in
            //刪除資料
            print("刪除按鈕被按下！！！")
            //Step1.先刪除資料庫資料
            //準備新增用的SQL指令
            let sql = "delete from student where no = ?"
            //將SQL指令轉換成C語言的字元陣列
            let cSql = sql.cString(using: .utf8)!
            //宣告儲存新增結果的指標
            var statement:OpaquePointer?
            //準備查詢（第三個參數若為正數則限定SQL指令的長度，若為負數則不限SQL指令的長度。第四個和第六個參數為預留參數，目前沒有作用。）
            if sqlite3_prepare_v3(self.db, cSql, -1, 0, &statement, nil) == SQLITE_OK
            {
                //準備綁定到第一個問號的資料
                let no = self.arrTable[indexPath.row].no.cString(using: .utf8)!
                sqlite3_bind_text(statement, 1, no, -1, nil)
                
                //執行Delete指令如果不成功
                if sqlite3_step(statement) != SQLITE_DONE
                {
                    //Step4.提示修改失敗訊息
                    //4-1.初始化訊息視窗
                    let alertController = UIAlertController(title: "資料庫訊息", message: "資料刪除失敗", preferredStyle: .alert)
                    //4-2.初始化訊息視窗使用的按鈕
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    //4-3.將按鈕加入訊息視窗
                    alertController.addAction(okAction)
                    //4-4.顯示訊息視窗
                    self.present(alertController, animated: true, completion: nil)
                    //關閉連線資料集
                    sqlite3_finalize(statement!)
                    //直接離開
                    return
                }
            }
            else
            {
                print("準備delete指令失敗！")
                return
            }
            //關閉連線資料集
            if statement != nil
            {
                sqlite3_finalize(statement!)
            }
            
            //Step2.刪除陣列資料
            self.arrTable.remove(at: indexPath.row)
//            print("刪除後的陣列：\(arrTable)")
            //Step3.刪除儲存格
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //設定按鈕組合
        let config = UISwipeActionsConfiguration(actions: [goAction,delAction])
        //設定是否可以滑動到底（true可以滑到底只顯示一個按鈕）
        config.performsFirstActionWithFullSwipe = false
        //回傳按鈕組合
        return config
    }
    
    //==================================================================================================
    
    

    //=====================================儲存格拖移相關作業===================================================
    //儲存拖移時
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
        //Step1.參數一：移除陣列原始位置的元素，直接加在新的位置
        arrTable.insert(arrTable.remove(at: fromIndexPath.row), at: to.row)

//        //確認交換過後的陣列位置
//        for (index,item) in arrTable.enumerated()
//        {
//            print("\(index)：\(item)")
//        }
        
        //Step2.更新資料庫中資料表的排序（如果有排序欄位的話）
        //--to do--
    }

    //哪一個儲存格允許拖移
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the item to be re-orderable.
        //所有儲存格都可以拖移
        return true
    }
    //==================================================================================================

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
//    {
//        //如果不允許特定儲存格進行編輯
//        if indexPath.row == 1
//        {
//            //回傳none
//            return .none
//        }
//        else
//        {
//            //允許編輯回傳delete或insert(通常不使用insert在儲存格上)
//            return .delete
//        }
//    }
    
*/

    // MARK: - Navigation

    //即將由導覽線換頁時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("即將由導覽線換頁")
        //由導覽線取得下一頁的執行實體
        let detailVC = segue.destination as! PhotoDetailViewController
        //通知下一頁目前本頁的執行實體所在位置
        detailVC.PhotoFileVC = self
    }

}
