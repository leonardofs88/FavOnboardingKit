import UIKit

public protocol FavOnboardingKitDelegate: AnyObject {
    func nextButtonDidTap(at index: Int)
    func getStartedButtonDidTap()
}

public class FavOnboardingKit {
    
    private let slides: [Slide]
    private let tintColor: UIColor
    fileprivate var rootVC: UIViewController?
    
    public weak var delegate: FavOnboardingKitDelegate?
    
    private lazy var onboardinViewController: OnboardingViewController = {
        let controller = OnboardingViewController(slides: slides, tintColor: tintColor)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.nextButtonDidTap = { [weak self] index in
            guard let self else { return }
            delegate?.nextButtonDidTap(at: index)
        }
        controller.getStartedButtonDidTap = { [weak self] in
            guard let self else { return }
            delegate?.getStartedButtonDidTap()
        }
        return controller
    }()
    
    public init(slides: [Slide], tintColor: UIColor) {
        self.slides = slides
        self.tintColor = tintColor
    }
    
    public func launchOnboarding(rootView: UIViewController) {
        rootVC = rootView
        rootView.present(onboardinViewController, animated: true, completion: nil)
    }
    
    public func dismissOnboarding() {
        onboardinViewController.stopAnimation()
        if rootVC?.presentedViewController == onboardinViewController {
            onboardinViewController.dismiss(animated: true)
        }
    }
    
    
}
