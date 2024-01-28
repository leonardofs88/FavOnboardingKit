//
//  File.swift
//  
//
//  Created by Leonardo Soares on 07/01/24.
//

import Foundation
import UIKit
import Combine

class AnimatedBarView: UIView {
    
    enum State {
        case clear
        case animating
        case filled
        
    }
    
    @Published fileprivate var barState: State = .clear
    
    fileprivate var subscribers = Set<AnyCancellable>()
    fileprivate lazy var animator: UIViewPropertyAnimator = setupAnimator()
    
    fileprivate lazy var backgroundBarView: UIView = {
       let view = UIView()
        view.backgroundColor = barColor.withAlphaComponent(0.2)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var foregroundBarView: UIView = {
        let view = UIView()
        view.backgroundColor = barColor
        view.alpha = 0.0
        return view
    }()
    
    fileprivate let barColor: UIColor
    
    init(barColor: UIColor) {
        self.barColor = barColor
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupAnimator() -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: 3.0, curve: .easeInOut) {
            self.foregroundBarView.transform = .identity
        }
    }
    
    fileprivate func observe() {
        $barState.sink { [unowned self] state in
            switch state {
            case .clear:
                animator = setupAnimator()
                foregroundBarView.alpha = 0.0
                animator.stopAnimation(false)
            case .animating:
                foregroundBarView.transform = .init(scaleX: 0, y: 1.0)
                foregroundBarView.transform = .init(translationX: -frame.size.width, y: 0)
                foregroundBarView.alpha = 1.0
                animator.startAnimation()
            case .filled:
                animator.stopAnimation(true)
                foregroundBarView.transform = .identity
            }
        }.store(in: &subscribers)
    }
    
    func startAnimating() {
        barState = .animating
    }
    
    func reset() {
        barState = .clear
    }
    
    func complete() {
        barState = .filled
    }
    
    fileprivate func layout() {
        addSubview(backgroundBarView)
        backgroundBarView.addSubview(foregroundBarView)
        
        backgroundBarView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        foregroundBarView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundBarView)
        }
    }
}
