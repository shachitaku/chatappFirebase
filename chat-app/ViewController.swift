//
//  ViewController.swift
//  chat-app
//
//  Created by Takumi Kimura on 2018/11/14.
//  Copyright © 2018年 com.takumi0kimura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var messageField : UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var sendView: UIView!
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.delegate = self
        
        //背景を黒くする
        self.view.backgroundColor = UIColor.black
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(type(of: self).openKeyboard(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
 
        _ = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(type(of: self).closeKeyboard(notification:)), name: UIResponder.keyboardDidHideNotification , object: nil)
        

        // databaseの接続をしている
        databaseRef = Database.database().reference().child("allmessages")
        
        
        //セッティングしている。新しいデータが入ってくるのを見張ってる。もしも、新しいデータが入ってきた場合{}内の処理を実行する。
        databaseRef.observe(DataEventType.childAdded, with: { snapshot in
            if  let name = (snapshot.value! as AnyObject).object(forKey: "name") as? String,
                let message = (snapshot.value! as AnyObject).object(forKey: "message") as? String
            {
                self.textView.text! = "\(self.textView.text!)\n\(name) : \(message)"
            }
            /*  \self.text.text!がないと、メッセージが全部同じラインに出る（前のメッセージが見れない）
                \nがないと、前のメッセージのすぐ右に、新しいメッセージが来る
            */
        })
    }
    
    

    @IBAction func buttonTapped(_ sender :  Any){
        let messageData = ["name": nameField.text!, "message": messageField.text!]
        // firebaseにdictionary型を保存するためデータを作成！
        
        databaseRef.childByAutoId().setValue(messageData)
        // データを保存！
        
        messageField.resignFirstResponder()
        //キーボードを閉じる
        messageField.text = ""
        //最終的にはtextFieldを空にする。
    }
    
    func tapped(recognizer: UITapGestureRecognizer){
        messageField.resignFirstResponder()
        nameField.resignFirstResponder()
    }
    
    
    @IBAction func clearChat(_ sender :  Any){
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "チャット履歴消していいの？", message: "消すときは、１回アプリ落とすから再起動してね" , preferredStyle:  UIAlertController.Style.alert)
        
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "消す！！", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            //ここで書いてるのに消えない・・・。
            self.databaseRef.removeValue()
            exit(0)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "やっぱやめる", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
        
        //アラート内で消すの無理だった・・・。（どっち押しても消える）
        self.databaseRef.removeValue()
    }

    //キーボードを開いたときに入力フィールドを移動させる
    @objc func openKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                // キーボードのサイズを取得
                let keyBoardRect = keyboard.cgRectValue
                
                //キーボードのサイズに合わせてずらす
                self.nameField.frame = CGRect(x: 5, y:(self.view.frame.height - 56 - keyBoardRect.size.height), width: self.view.frame.width - 70, height: 28)
                self.messageField.frame = CGRect(x: 5, y:(self.view.frame.height - 28 - keyBoardRect.size.height), width: self.view.frame.width - 70, height: 28)
                self.sendView.frame = CGRect(x: 0, y: (self.view.frame.height - 60 - keyBoardRect.size.height), width: self.view.frame.width, height: 64)
                self.sendButton.frame = CGRect(x: self.view.frame.width - 55, y: (self.view.frame.height - 42 - keyBoardRect.size.height), width: 50, height: 28)
                self.textView.frame = CGRect(x: 16, y: 83, width: 343, height: UIScreen.main.bounds.size.height - keyBoardRect.size.height - self.sendView.frame.height - self.textView.frame.minY - 10)
            }
        }
    }
    
    //キーボードを閉じた時に入力フィールドを元の位置に戻す
    @objc func closeKeyboard(notification: NSNotification) {
                self.nameField.frame = CGRect(x: 16, y: 624, width: 159, height: 30)
                self.messageField.frame = CGRect(x: 16, y: 681, width: 343, height: 30)
                self.sendView.frame = CGRect(x: 0, y: 602, width: 375, height: 176)
                self.sendButton.frame = CGRect(x: 318, y: 624, width: 36, height: 30)
                self.textView.frame = CGRect(x: 16, y: 83, width: 343, height: 504)
            }
}


