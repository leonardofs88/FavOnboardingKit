//
//  File.swift
//
//
//  Created by Leonardo Soares on 02/01/24.
//

import Foundation
import UIKit


class OnboardingViewController: UIViewController {
    var nextButtonDidTap: ((Int) -> Void)?
    var getStartedButtonDidTap: (() -> Void)?
    private let slides: [Slide]
    private let tintColor: UIColor
    private let themeFont: UIFont
    
    private lazy var transitionView: TransitionView = {
        let view = TransitionView(slides: slides, viewTintColor: tintColor, themeFont: themeFont)
        return view
    }()
    
    private lazy var buttonContainer: ButtonContainerView = {
        let view = ButtonContainerView(viewTintColor: tintColor)
        view.nextButtonDidTap = { [weak self] in
            guard let self else { return }
            self.nextButtonDidTap?(self.transitionView.index)
            self.transitionView.handleTap(direction: .right)
        }
        
        view.getStartedButtonDidTap = { [weak self] in
            guard let self else { return }
            self.getStartedButtonDidTap?()
        }
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [transitionView, buttonContainer])
        view.axis = .vertical
        return view
    }()
    
    init(slides: [Slide], tintColor: UIColor, themeFont: UIFont) {
        self.slides = slides
        self.tintColor = tintColor
        self.themeFont = themeFont
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionView.start()
    }
    
    func stopAnimation() {
        transitionView.stop()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        buttonContainer.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
    }
    
    fileprivate func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(_:)))
        transitionView.addGestureRecognizer(gesture)
    }
    
    @objc private func viewDidTap(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: view)
        let midPoint = view.frame.size.width / 2
        transitionView.handleTap(direction: point.x > midPoint ? .right : .left)
    }
}

