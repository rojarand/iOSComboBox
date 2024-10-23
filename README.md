# UIComboBox

**UIComboBox** is a customizable combo box (drop-down) view for iOS, designed to provide a simple way to integrate a selection interface into your apps.

## Features

- Customizable appearance
- Supports both static and dynamic data
- Smooth animations for the dropdown
- Easy integration with both Storyboard and programmatically
- Swift and Objective-C compatibility

## Requirements

- iOS 12.0+
- Swift 5.0+
- Xcode 12.0+

## Installation

### Swift Package Manager

UIComboBox supports installation via [Swift Package Manager](https://github.com/swiftlang/swift-package-manager), which is built into Xcode.

1. In Xcode, select File > **Add Packages...**
2. Paste the repository URL into the search field:
```
https://github.com/yourusername/UIComboBox
```
3. Select the version or branch you want to use.
4. Click Add Package to add it to your project.

### CocoaPods

To integrate UIComboBox using CocoaPods, follow these steps:

1. Add UIComboBox to your `Podfile`:
```yaml
pod 'UIComboBox', '~> 1.0.0'
```
2. Install the pod by running the following command in your terminal:
```terminal
[bundle exec] pod install
```
3. Open your project via the generated `.xcworkspace` file.

## Usage

### Programmatic Usage

Here's an example of how to use UIComboBox programmatically:
```swift
import UIComboBox

let comboBox = UIComboBox(frame: CGRect(x: 20, y: 100, width: 280, height: 40))
comboBox.items = ["Option 1", "Option 2", "Option 3"]
comboBox.placeholder = "Select an option"
comboBox.onSelectionChanged = { selectedItem in
    print("Selected: \(selectedItem)")
}
self.view.addSubview(comboBox)
```

### Storyboard Usage
1. Drag a UIView onto your storyboard.
2. Set its class to UIComboBox in the Identity Inspector.
3. Configure the control's properties in the Attributes Inspector or programmatically.

#### Connecting to Your Code
```swift
@IBOutlet weak var comboBox: UIComboBox!

override func viewDidLoad() {
    super.viewDidLoad()
    
    comboBox.items = ["Item 1", "Item 2", "Item 3"]
    comboBox.onSelectionChanged = { selectedItem in
        print("Selected item: \(selectedItem)")
    }
}
```

## Customization

**UIComboBox** allows you to customize various aspects of the control:

**Items**: Set the items in the dropdown using the `items` property.
**Placeholder**: Set placeholder text using the `placeholder` property.
**Dropdown Appearance**: Customize the dropdown's height, font, and colors.
**Selection Callback**: Use the `onSelectionChanged` closure to handle selection changes.

## Example
To explore a full example, check out the UIComboBoxApp folder in this repository, which demonstrates how to integrate and use UIComboBox in various scenarios.

## License
UIComboBox is released under the MIT license. See [LICENSE](https://en.wikipedia.org/wiki/MIT_License) for details.

