//
//  Constants.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//
import SpriteKit

struct Constants {
    static let DEFAULT_BALL_RADIUS = 15
    static let OBJECT_MOVE_SPEED = 50.0
    static let VERTICAL_COLLECTABLE_BOUNDS = CGRect(x: 0, y: 0, width: 15, height: 20)
    static let HORIZONTAL_COLLECTABLE_BOUNDS = CGRect(x: 0, y: 0, width: 20, height: 15)
    static let PERCENT_BADDIES = 0.5
    static let COLLECTABLE_SPAWN_CHANCE = 0.25
    static let BALL_SIZE_DELTA = 5
    static let BALL_SIZE_MAX = DEFAULT_BALL_RADIUS + (BALL_SIZE_DELTA * 2)
    
}

enum NodeNames: String {
    case ball = "ball"
    case goody = "goody"
    case baddy = "baddy"
    case button = "button"
}

enum Direction: CaseIterable {
    case north, south, east, west
  
}
