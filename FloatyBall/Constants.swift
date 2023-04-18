//
//  Constants.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//
import SpriteKit

struct Constants {
    static let BALL_RADIUS = 15
    static let COLLECTABLE_MOVE_SPEED = 50.0
    static let collectableBounds = CGRect(x: 0, y: 0, width: 15, height: 25)
}

enum NodeNames: String {
    case ball = "ball"
    case goody = "goody"
    case baddy = "baddy"
    case button = "button"
}

enum Direction {
    case north, south, east, west
}
