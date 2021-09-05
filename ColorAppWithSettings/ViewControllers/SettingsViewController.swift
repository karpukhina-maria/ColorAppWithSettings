//
//  SettingsViewController.swift
//  ColorAppWithSettings
//
//  Created by Mary Jane on 04.09.2021.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redSliderValue: UILabel!
    @IBOutlet var greenSliderValue: UILabel!
    @IBOutlet var blueSliderValue: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redValueTextField: UITextField!
    @IBOutlet var greenValueTextField: UITextField!
    @IBOutlet var blueValueTextField: UITextField!
    
    var bgcolor: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        blueSlider.minimumTrackTintColor = .blue
        
        updateColorView()
        updateSliders(redSlider, greenSlider, blueSlider)
        updateSlidersValues(for: redSliderValue, greenSliderValue, blueSliderValue)
        updatesTextFieldValues(for: redValueTextField, greenValueTextField, blueValueTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed() {
        view.endEditing(true)
        delegate.updateBackgroundColor(with: bgcolor)
        dismiss(animated: true)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        bgcolor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
        
        updateColorView()
        switch sender {
        case redSlider:
            updatesTextFieldValues(for: redValueTextField)
            updateSlidersValues(for: redSliderValue)
        case greenSlider:
            updatesTextFieldValues(for: greenValueTextField)
            updateSlidersValues(for: greenSliderValue)
        default:
            updatesTextFieldValues(for: blueValueTextField)
            updateSlidersValues(for: blueSliderValue)
        }
    }
    
    private func updateColorView() {
        colorView.backgroundColor = bgcolor
    }
    
    private func updateSliders(_ sliders: UISlider...) {
        for slider in sliders {
            switch slider {
            case redSlider:
                redSlider.value = Float(bgcolor.rgba.red)
            case greenSlider:
                greenSlider.value =  Float(bgcolor.rgba.green)
            default:
                blueSlider.value = Float(bgcolor.rgba.blue)
            }
        }
    }
    
    private func string(from float: Float) -> String {
        String(format: "%.2f", float)
    }
    
    private func float(from textField: UITextField) -> Float {
        return Float(textField.text ?? "0") ?? Float(0.0)
    }
    
    
    private func updateSlidersValues(for labels: UILabel...) {
        for label in labels {
            switch label {
            case redSliderValue:
                label.text = string(from: redSlider.value)
            case greenSliderValue:
                label.text = string(from: greenSlider.value)
            default:
                label.text = string(from: blueSlider.value)
            }
        }
    }
    
    private func updatesTextFieldValues(for textFields: UITextField...) {
        for textField in textFields {
            switch textField {
            case redValueTextField:
                textField.text = string(from: redSlider.value)
            case greenValueTextField:
                textField.text = string(from: greenSlider.value)
            default:
                textField.text = string(from: blueSlider.value)
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if float(from: textField) < 0 || float(from: textField) > 1 {
            textField.text = string(from: 0.5)
        } else {
            switch textField {
            case redValueTextField:
                bgcolor = UIColor(
                    red: CGFloat(float(from: textField)),
                    green: CGFloat(bgcolor.rgba.green),
                    blue: CGFloat(bgcolor.rgba.blue),
                    alpha: 1
                )
                updateSliders(redSlider)
                updateSlidersValues(for: redSliderValue)
            case greenValueTextField:
                bgcolor = UIColor(
                    red: CGFloat(bgcolor.rgba.red),
                    green: CGFloat(float(from: textField)),
                    blue: CGFloat(bgcolor.rgba.blue),
                    alpha: 1
                )
                updateSliders(greenSlider)
                updateSlidersValues(for: greenSliderValue)
            default:
                bgcolor = UIColor(
                    red: CGFloat(bgcolor.rgba.red),
                    green: CGFloat(bgcolor.rgba.green),
                    blue: CGFloat(float(from: textField)),
                    alpha: 1
                )
                updateSliders(blueSlider)
                updateSlidersValues(for: blueSliderValue)
            }
        }
        textField.text = string(from: float(from: textField))
        updateColorView()
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

//MARK: - work with keyboard
extension SettingsViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == redValueTextField {
            greenSliderValue.becomeFirstResponder()
        } else if textField == greenValueTextField {
            blueSliderValue.becomeFirstResponder()
        } else if textField == blueValueTextField {
            redSliderValue.becomeFirstResponder()
        }
        return true
    }
}
