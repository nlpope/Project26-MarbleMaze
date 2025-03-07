//
//  Constants+utils.swift
//  Project26-MarbleMaze
//
//  Created by Noah Pope on 12/14/24.
//

import Foundation

enum CollisionTypes: UInt32
{
    case player = 1
    case wall   = 2
    case star   = 4
    case vortex = 8
    case finish = 16
}

enum ImageNames
{
    static let block        = "block"
    // is this why i was getting x's (".png")?
    static let vortex       = "vortex.png"
    static let star         = "star"
    static let finish       = "finish"
    static let background   = "background"
    static let player       = "player"
}

enum NodeNames
{
    static let vortex       = "vortex"
    static let star         = "star"
    static let finish       = "finish"
    static let background   = "background"
}

enum FontNames
{
    static let chalkDuster  = "Chalkduster"
}
