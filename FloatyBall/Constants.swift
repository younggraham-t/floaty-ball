//
//  Constants.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//
import SpriteKit

struct Constants {
    
    static let SPAWN_COLLECTABLE_TIME = 3.5
    
    static let OBJECT_MOVE_SPEED = 150.0
    static let DELTA_OBJECT_SPEED = 50.0
    
    static let VERTICAL_COLLECTABLE_BOUNDING_BOX = CGRect(x: 0, y: 0, width: 15, height: 20)
    static let HORIZONTAL_COLLECTABLE_BOUNDING_BOX = CGRect(x: 0, y: 0, width: 20, height: 15)
    
    static let PERCENT_BADDIES = 0.5
    static let COLLECTABLE_SPAWN_CHANCE = 0.05
    
    static let DEFAULT_BALL_RADIUS = 10
    static let BALL_SIZE_DELTA = 5
    static let BALL_SIZE_MAX_DIAMETER = (DEFAULT_BALL_RADIUS + (BALL_SIZE_DELTA * 2)) * 2
    
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
