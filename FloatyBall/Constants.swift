//
//  Constants.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//
import SpriteKit

struct Constants {
    
    static let SPAWN_COLLECTABLE_TIME = 3.0
    
    static let OBJECT_MOVE_SPEED = 150.0
    static let DELTA_OBJECT_SPEED = 50.0
   
    static let COLLECTABLE_SHORT_AXIS_LENGTH = 15.0
    static let COLLECTABLE_LONG_AXIS_LENGTH = 20.0
    static let VERTICAL_COLLECTABLE_BOUNDING_BOX = CGRect(x: 0, y: 0, width: COLLECTABLE_SHORT_AXIS_LENGTH, height: COLLECTABLE_LONG_AXIS_LENGTH)
    static let HORIZONTAL_COLLECTABLE_BOUNDING_BOX = CGRect(x: 0, y: 0, width: COLLECTABLE_LONG_AXIS_LENGTH, height: COLLECTABLE_SHORT_AXIS_LENGTH)
    
    static let PERCENT_BADDIES = 0.5
    static let COLLECTABLE_SPAWN_CHANCE = 0.05
    
    static let DEFAULT_BALL_RADIUS = 10
    static let BALL_SIZE_DELTA = 5
    static let BALL_SIZE_MAX_DIAMETER = (DEFAULT_BALL_RADIUS + (BALL_SIZE_DELTA * 2)) * 2
    
    static let TOUCH_TOLERANCE = 75.0
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
