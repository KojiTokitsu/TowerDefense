//
//  GameScene.swift
//  TowerDefense
//
//  Created by 時津幸司 on 2016/05/25.
//  Copyright (c) 2016年 時津幸司. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum State{
        case Playing
        case GameClear
        case GameOver
    }
    let playerContact:UInt32 = 0x1 << 0
    let enemyContact:UInt32 = 0x1 << 1
    
    let player = SKSpriteNode(imageNamed: "Player")
    let enemy = SKSpriteNode(imageNamed: "Enemy")
    var state = State.Playing
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        //　背景
        let fieldImageLength:CGFloat = 32
        for i in 0...Int(frame.size.width / fieldImageLength) + 1{
            for j in 0...Int(frame.size.height / fieldImageLength) + 1{
                let field = SKSpriteNode(imageNamed: "Field")
                field.position = CGPoint(x: CGFloat(i) * fieldImageLength, y: CGFloat(j) * fieldImageLength)
                field.zPosition = -1
                addChild(field)
            }
        }
        
        // 敵
        enemy.position = CGPoint(x: 50, y: 300)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        addChild(enemy)
        
        // プレーヤー
        player.position = CGPoint(x: 250, y: 300)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.contactTestBitMask = playerContact
        addChild(player)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        state = .GameClear
        enemy.removeFromParent()
        
        let label = SKLabelNode(fontNamed: "HiraginoSans-W6")
        label.text = "ゲームクリア"
        label.fontSize = 45
        label.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
        addChild(label)
    }

    override func update(currentTime: CFTimeInterval) {
        if state == .Playing{
            enemy.position.x += 1
            if frame.width < enemy.position.x{
                state = .GameOver
                let label = SKLabelNode(fontNamed: "HiraginoSans-W6")
                label.text = "ゲームオーバー"
                label.fontSize = 45
                label.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
                addChild(label)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let prevLocation = touch.previousLocationInNode(self)
        player.position.x += location.x - prevLocation.x
        player.position.y += location.y - prevLocation.y
    }
}
