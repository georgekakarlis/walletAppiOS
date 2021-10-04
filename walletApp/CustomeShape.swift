//
//  CustomeShape.swift
//  walletApp
//
//  Created by George Kakarlis on 3/10/21.
//

import SwiftUI

struct CustomeShape: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath (roundedRect: rect,
                                     byRoundingCorners: corners,
                                           cornerRadii: CGSize(width: radius,
                                                      height: radius))
        return Path(path.cgPath)
    }
    
    }



