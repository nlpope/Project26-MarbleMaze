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
    static let block    = "block"
    static let vortex   = "vortex"
}

enum NodeNames
{
    static let vortex   = "vortex"
}
