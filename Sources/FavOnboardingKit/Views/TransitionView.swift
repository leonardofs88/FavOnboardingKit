//
//  File.swift
//
//
//  Created by Leonardo Soares on 07/01/24.
//

import Foundation
import UIKit

class TransitionView: UIView {
    
    fileprivate var timer: DispatchSourceTimer?
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var barViews: [AnimatedBarView] = {
        var views: [AnimatedBarView] = []
        slides.forEach { _ in
            views.append(AnimatedBarView(barColor: viewTintColor))
        }
        return views
    }()
    
    fileprivate lazy var barStackView: UIStackView = {
        let stackView = UIStackView()
        barViews.forEach { barView in
            stackView.addArrangedSubview(barView)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    fileprivate lazy var titleView: TitleView = {
        TitleView()
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    fileprivate let slides: [Slide]
    fileprivate let viewTintColor: UIColor
    fileprivate(set) var index = -1
    
    init(slides: [Slide], viewTintColor: UIColor) {
        self.slides = slides
        self.viewTintColor = viewTintColor
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        buildTimerIfNeeded()
        timer?.resume()
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    fileprivate func buildTimerIfNeeded() {
        guard timer == nil else { return }
        
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: .seconds(3), leeway: .seconds(1))
        timer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.showNext()
            }
        })
    }
    
    fileprivate func showNext() {
        // if index is last, then show first
        // else, show next index
        
        let next: UIImage
        let nextTitle: String
        let nextBarView: AnimatedBarView
        
        if slides.indices.contains(index + 1) {
            next = slides[index + 1].image
            nextTitle = slides[index + 1].title
            nextBarView = barViews[index + 1]
            index += 1
        } else {
            barViews.forEach { $0.reset() }
            next = slides[0].image
            nextTitle = slides[0].title
            nextBarView = barViews[0]
            index = 0
        }
        
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve) {
            self.imageView.image = next
            self.titleView.setTitle(text: nextTitle)
            nextBarView.startAnimating()
        }
    }
    
    fileprivate func layout() {
        
        addSubview(stackView)
        addSubview(barStackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        barStackView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.top.equalTo(snp.topMargin)
            make.height.equalTo(4)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.8)
        }
    }
    
    func handleTap(direction: Direction) {
        switch direction {
        case .left:
            barViews[index].reset()
            if barViews.indices.contains(index - 1) {
                barViews[index - 1].reset()
            }
            index -= 2
        case .right:
            barViews[index].complete()
        }
        timer?.cancel()
        timer = nil
        start()
    }
}
