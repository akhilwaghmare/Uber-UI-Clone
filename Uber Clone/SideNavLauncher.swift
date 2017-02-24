//
//  SideNavController.swift
//  Uber Clone
//
//  Created by Akhil Waghmare on 1/6/17.
//  Copyright © 2017 AW Labs. All rights reserved.
//

import UIKit

class SideNavLauncher: NSObject {

    lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissNav)))
        return view
    }()
    
    let sideMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var menuWidth: CGFloat = 100
    
    func showNav() {
        if let window = UIApplication.shared.keyWindow {
            menuWidth = window.frame.width * 0.75
            
            window.addSubview(blackView)
            blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
            window.addSubview(sideMenu)
            sideMenu.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: window.frame.height)
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.sideMenu.frame = CGRect(x: 0, y: 0, width: self.menuWidth, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func dismissNav() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.2, animations: {
                self.blackView.alpha = 0
                self.sideMenu.frame = CGRect(x: -self.menuWidth, y: 0, width: self.menuWidth, height: window.frame.height)
            }) { (completed) in
                window.willRemoveSubview(self.blackView)
                window.willRemoveSubview(self.sideMenu)
            }
        }
    }
}
