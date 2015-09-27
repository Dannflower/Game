//
//  VectorMath.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/18/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import Foundation

class VectorMath {
    
    // Computes the distance between two vectors
    class func distance(start: CGVector, end: CGVector) -> CGFloat {
        
        let differenceVector: CGVector = difference(start, vector2: end)
        
        return length(differenceVector)
    }
    
    // Computes the difference vector between two vectors
    class func difference(vector1: CGVector, vector2: CGVector) -> CGVector {
        
        return CGVectorMake(vector2.dx - vector1.dx, vector2.dy - vector1.dy)
    }
    
    // Computes the length of a vector
    class func length(vector: CGVector) -> CGFloat {
        
        return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        
    }
    
    // Returns the normalized version of the vector
    class func normalize(vector: CGVector) -> CGVector {
        
        return divide(vector, divisor: length(vector))
    }
    
    // Computes the quotient of the two vectors
    class func divide(divedend: CGVector, divisor: CGFloat) -> CGVector {
        
        return CGVectorMake(divedend.dx / divisor, divedend.dy / divisor)
    }
    
    // Computes the vector representing movement direction and magnitude to reach the destination
    // position from the current position per unit time
    class func computeDirectionToMoveVector(currentPosition: CGVector, destinationPosition: CGVector) -> CGVector {
        
        return normalize(difference(currentPosition, vector2: destinationPosition))
    }
    
    // 
    class func computeNewPosition(currentPosition: CGVector, directionVector: CGVector, speed: CGFloat) -> CGPoint {
        
        return CGPointMake(currentPosition.dx + directionVector.dx * speed, currentPosition.dy + directionVector.dy * speed)
    }
}