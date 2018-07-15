//
//  RSPagedLineView.swift
//  RSPagedViewController
//
//  Created by Rodrigo Soldi on 13/07/18.
//  Copyright © 2018 Soldi Inc. All rights reserved.
//

import Foundation

class RSPagedLineView: UIView {
    
    var color: UIColor = .black
    
    init(color: UIColor = .black) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.color = color
        
        let lineView = self.lineView        
        self.addSubview(lineView)
        
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.color
        return view
    }()
    
}
