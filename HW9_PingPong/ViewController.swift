//
//  ViewController.swift
//  HW9_PingPong
//
//  Created by 蔡尚諺 on 2021/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btMainScoreLeft: UIButton!
    @IBOutlet weak var btMainScoreRight: UIButton!
    @IBOutlet weak var btScoreLeft: UIButton!
    @IBOutlet weak var btScoreright: UIButton!
    @IBOutlet weak var lbServeLeft: UILabel!
    @IBOutlet weak var lbServeRight: UILabel!
    
    @IBOutlet weak var btMoon: UIButton!
    @IBOutlet weak var btChangeSide: UIButton!
    @IBOutlet weak var btRewind: UIButton!
    
    //發球方判斷
    var serveScore = 0
    
    //換顏色
    var darkMode = false
    
    //延長賽
    var duce = false
    
    //左邊選手
    var leftPlayer = ScoreRecord(serve: true)
    //右邊選手
    var rightPlayer = ScoreRecord(serve: false)
    //record
    var records = [Record]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.userInterfaceStyle == .light {
            darkMode = false
        }else if traitCollection.userInterfaceStyle == .dark{
            darkMode = true
        }
        
        refreshUI()
    }
    
    //橫向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
    
    //加分數
    @IBAction func addScore(_ button: UIButton) {
        //Keep 改變前紀錄
        keepRecord(leftPlayer: leftPlayer, rightPlayer: rightPlayer, duce: duce, darkMode: darkMode, serveScore: serveScore)
        
        //當局分數計算
        if button === btScoreLeft{
            leftPlayer.score += 1
            serveScore += 1
            
            if duce == true {
                serveScore = 2
                leftPlayer.duceScore += 1
                rightPlayer.duceScore = 0
            }
            
        }else if button === btScoreright{
            rightPlayer.score += 1
            serveScore += 1
            
            if duce == true {
                serveScore = 2
                rightPlayer.duceScore += 1
                leftPlayer.duceScore = 0
            }
            
        }else if button === btMainScoreLeft{
            leftPlayer.mainScore += 1
        }else if button === btMainScoreRight{
            rightPlayer.mainScore += 1
        }
        
        //賽末點判斷
        if leftPlayer.score == 11
            && duce == false {
            
            leftPlayer.score = 0
            rightPlayer.score = 0
            leftPlayer.mainScore += 1
            
        }else if rightPlayer.score == 11
                    && duce == false {
            
            leftPlayer.score = 0
            rightPlayer.score = 0
            rightPlayer.mainScore += 1
            
            //duce
        }else if leftPlayer.score == rightPlayer.score
                    && leftPlayer.score == 10
                    && rightPlayer.score == 10{
            duce = true
            
            //duce賽末點
        }else if duce == true {
            if leftPlayer.duceScore == 2 {
                
                leftPlayer.score = 0
                rightPlayer.score = 0
                leftPlayer.duceScore = 0
                rightPlayer.duceScore = 0
                leftPlayer.mainScore += 1
                duce = false
                
            }else if rightPlayer.duceScore == 2 {
                leftPlayer.score = 0
                rightPlayer.score = 0
                leftPlayer.duceScore = 0
                rightPlayer.duceScore = 0
                rightPlayer.mainScore += 1
                duce = false
            }
        }
        
        //發球權判斷
        checkServeChange(serveScore: serveScore)
        //更新UI畫面
        refreshUI()
    }
    
    //換邊
    func switchPosition() {
        //Keep 改變前紀錄
        keepRecord(leftPlayer: leftPlayer, rightPlayer: rightPlayer, duce: duce, darkMode: darkMode, serveScore: serveScore)
        
        let leftPlayerTemp = leftPlayer
        let rightPlayerTemp = rightPlayer
        
        leftPlayer = rightPlayerTemp
        rightPlayer = leftPlayerTemp
        
    }
    
    //更新畫面
    func refreshUI() {
        
        //本局分數
        var attribute = AttributedString("\(leftPlayer.score)")
        attribute.font = UIFont.systemFont(ofSize: 150)
        btScoreLeft.configuration?.attributedTitle = attribute
        
        attribute = AttributedString("\(rightPlayer.score)")
        attribute.font = UIFont.systemFont(ofSize: 150)
        btScoreright.configuration?.attributedTitle = attribute
        
        //總比數
        attribute = AttributedString("\(leftPlayer.mainScore)")
        attribute.font = UIFont.systemFont(ofSize: 100)
        btMainScoreLeft.configuration?.attributedTitle = attribute
        
        attribute = AttributedString("\(rightPlayer.mainScore)")
        attribute.font = UIFont.systemFont(ofSize: 100)
        btMainScoreRight.configuration?.attributedTitle = attribute
        
        //顯示&隱藏Serve
        if leftPlayer.serve {
            lbServeLeft.isHidden = false
            lbServeRight.isHidden = true
            
        }else{
            lbServeLeft.isHidden = true
            lbServeRight.isHidden = false
        }
        
        //dark mode
        if darkMode {
            view.backgroundColor = .darkGray
            btMainScoreLeft.tintColor = .white
            btMainScoreRight.tintColor = .white
            btScoreLeft.tintColor = .white
            btScoreright.tintColor = .white
            lbServeLeft.textColor = .white
            lbServeRight.textColor = .white
            btChangeSide.tintColor = .white
            btRewind.tintColor = .white
            btMoon.tintColor = .white
        }else{
            view.backgroundColor = .white
            btMainScoreLeft.tintColor = .systemBlue
            btMainScoreRight.tintColor = .systemBlue
            btScoreLeft.tintColor = .systemBlue
            btScoreright.tintColor = .systemBlue
            lbServeLeft.textColor = .black
            lbServeRight.textColor = .black
            btChangeSide.tintColor = .systemBlue
            btRewind.tintColor = .systemBlue
            btMoon.tintColor = .systemBlue
        }
        
    }
    
    func checkServeChange(serveScore: Int) {
        //分數等於二才做
        guard serveScore == 2 else {return}
        
        self.serveScore = 0
        serveChange()
        
    }
    
    //更換發球權
    func serveChange() {
        
        if leftPlayer.serve {
            leftPlayer.serve = false
            lbServeLeft.isHidden = true
            rightPlayer.serve = true
            lbServeRight.isHidden = false
            
        }else{
            leftPlayer.serve = true
            lbServeLeft.isHidden = false
            rightPlayer.serve = false
            lbServeRight.isHidden = true
            
        }
    }
    
    //keep目前紀錄
    func keepRecord(leftPlayer: ScoreRecord ,rightPlayer: ScoreRecord ,duce: Bool , darkMode: Bool,serveScore: Int ) {
        //keep改變前紀錄
        let record = Record(leftPlayer: leftPlayer, rightPlayer: rightPlayer, duce: duce, darkMode: darkMode,serveScore: serveScore)
        records.append(record)
        //最多只留10筆
        if checkRecordsLine(records: records) > 10 {
            records.removeFirst()
        }
    }
    
    //檢查目前儲存幾筆紀錄
    func checkRecordsLine(records: [Record]) -> Int {
        let line = records.count
        return line
    }
    
    //換邊
    @IBAction func changeSide(_ sender: UIButton) {
        //Keep 改變前紀錄
        keepRecord(leftPlayer: leftPlayer, rightPlayer: rightPlayer, duce: duce, darkMode: darkMode, serveScore: serveScore)
        
        switchPosition()
        refreshUI()
    }
    
    //重置
    @IBAction func reset(_ sender: UIButton) {
        //Keep 改變前紀錄
        keepRecord(leftPlayer: leftPlayer, rightPlayer: rightPlayer, duce: duce, darkMode: darkMode, serveScore: serveScore)
        
        leftPlayer = ScoreRecord(serve: true)
        rightPlayer = ScoreRecord(serve: false)
        serveScore = 0
        refreshUI()
    }
    
    //換顏色
    @IBAction func darkMode(_ sender: UIButton) {
        //Keep 改變前紀錄
        keepRecord(leftPlayer: leftPlayer, rightPlayer: rightPlayer, duce: duce, darkMode: darkMode, serveScore: serveScore)
        
        if darkMode {
            darkMode = false
        }else{
            darkMode = true
        }
        
        refreshUI()
    }
    
    //回前一動
    @IBAction func rewind(_ sender: UIButton) {
        //不是空的才要做
        guard !records.isEmpty else {return}
        
        let record = records.last
        leftPlayer = record!.leftPlayer
        rightPlayer = record!.rightPlayer
        darkMode = record!.darkMode
        duce = record!.duce
        serveScore = record!.serveScore
        
        records.removeLast()
        
        refreshUI()
        
    }
    
}

