import UIKit
import Capacitor

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ScreenOrientationPlugin"
    public let jsName = "ScreenOrientation"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "lockLandscape", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "lockPortrait", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "unlock", returnType: CAPPluginReturnPromise)
    ]

    @objc func lockLandscape(_ call: CAPPluginCall) {
        setOrientation(mask: .landscape, orientation: .landscapeRight)
        call.resolve()
    }

    @objc func lockPortrait(_ call: CAPPluginCall) {
        setOrientation(mask: .portrait, orientation: .portrait)
        call.resolve()
    }

    @objc func unlock(_ call: CAPPluginCall) {
        setOrientation(mask: .allButUpsideDown, orientation: .unknown)
        call.resolve()
    }

    private func setOrientation(mask: UIInterfaceOrientationMask, orientation: UIInterfaceOrientation) {
        DispatchQueue.main.async { [weak self] in
            guard let viewController = self?.bridge?.viewController as? CAPBridgeViewController else {
                return
            }

            viewController.supportedOrientations = Self.orientationValues(for: mask)
            viewController.setNeedsUpdateOfSupportedInterfaceOrientations()

            if #available(iOS 16.0, *), let windowScene = viewController.view.window?.windowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask)) { error in
                    CAPLog.print("ScreenOrientation geometry update failed: \(error.localizedDescription)")
                }
            } else if orientation != .unknown {
                UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }

    private static func orientationValues(for mask: UIInterfaceOrientationMask) -> [Int] {
        var values: [Int] = []
        if mask.contains(.portrait) {
            values.append(UIInterfaceOrientation.portrait.rawValue)
        }
        if mask.contains(.portraitUpsideDown) {
            values.append(UIInterfaceOrientation.portraitUpsideDown.rawValue)
        }
        if mask.contains(.landscapeLeft) {
            values.append(UIInterfaceOrientation.landscapeLeft.rawValue)
        }
        if mask.contains(.landscapeRight) {
            values.append(UIInterfaceOrientation.landscapeRight.rawValue)
        }
        return values.isEmpty ? [UIInterfaceOrientation.portrait.rawValue] : values
    }
}
