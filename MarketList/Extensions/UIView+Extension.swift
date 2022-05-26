//
//  UIView+Extension.swift
//  MarketList
//
//  Created by UNAM FCA 06 on 24/05/22.
//

import UIKit

extension UIView{
   @IBInspectable var cornerRadius: CGFloat{
        get { return cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
