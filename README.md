# CBDateRangePicker - iOS - Swift - SwiftUI

CBDateRangePicker is a DatePickerView that returns a date range by selecting the start date and the last date.

[![SwiftMP compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5-green.svg?style=flat)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-14-blue.svg?style=flat)](https://developer.apple.com/xcode)
[![License](https://img.shields.io/badge/license-mit-brightgreen.svg?style=flat)](https://en.wikipedia.org/wiki/MIT_License)

![Simulator Screen Recording - iPhone 14 Pro - 2023-08-22 at 16 57 37](https://github.com/CobyLibrary/CBDateRangePicker/assets/57849386/98c4b478-46c1-44c5-9e53-6824683c958a)


## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+

## Installation

#### Swift Package Manager
```
File -> Swift Packages -> Add Package Dependency

https://github.com/CobyLibrary/CBDateRangePicker.git
```

## Usage

### Quick Start

```swift
import CBDateRangePicker

struct CBDateRangePickerTestView: View {
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        VStack {
            CBDateRangePickerView(
                startDate: $startDate,
                endDate: $endDate
            )
            .background(Color.white)
            .padding()
            .frame(height: 200)
            
            ...
        }
    }
}
```

## Show parameters

- startDate: Binding<Date> **(Required)**
- endDate: Binding<Date> **(Required)**
- toToday: Bool

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
