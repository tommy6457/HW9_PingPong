//
//  ScoreRecord.swift
//  HW9_PingPong
//
//  Created by 蔡尚諺 on 2021/11/23.
//

import Foundation

struct ScoreRecord {
    //總比分
    var mainScore = 0
    //當局比分
    var score = 0
    //發球權
    var serve: Bool
    //duce分數
    var duceScore = 0
    
    init(serve: Bool) {
        self.serve = serve
    }
    
}


