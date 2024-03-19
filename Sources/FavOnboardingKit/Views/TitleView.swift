//
//  File.swift
//  
//
//  Created by Leonardo Soares on 07/01/24.
//

import Foundation
import UIKit

class TitleView: UIView {
    
    private let themeFont: UIFont
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = themeFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    init(themeFont: UIFont) {
        self.themeFont = themeFont
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(text: String?) {
        titleLabel.text = text
    }
    
    fileprivate func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.bottom.equalTo(snp.bottom).offset(-36)
            make.leading.equalTo(snp.leading).offset(36)
            make.trailing.equalTo(snp.trailing).offset(-36)
        }
    }
    
}
