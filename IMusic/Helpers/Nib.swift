//
//  Nib.swift
//  IMusic
//
//  Created by Светлана Шардакова on 29.06.2020.
//  Copyright © 2020 Светлана Шардакова. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
