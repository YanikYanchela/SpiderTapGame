//
//  ModelGame.swift
//  SpiderTapGame
//
//  Created by Дмитрий Яновский on 1.04.24.
//

import Foundation


class ModelGame {
    
    var score: Int
    var gameTime: Int
    var currentTime: Int
    
    init(score: Int, gameTime: Int, currentTime: Int) {
        self.score = score
        self.gameTime = gameTime
        self.currentTime = currentTime
    }
    
    func incrementScore() {
        score += 1
    }
    
    func updateTime() {
        currentTime += 1
    }
    
    func reset() {
        score = 0
        currentTime = 0
        
    }
}
