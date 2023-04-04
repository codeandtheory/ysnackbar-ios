![Y—Snackbar](https://user-images.githubusercontent.com/1037520/221581980-3961ac0e-2804-4a91-a129-918788dd3353.jpeg)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyml-org%2Fysnackbar-ios%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yml-org/ysnackbar-ios) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyml-org%2Fysnackbar-ios%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yml-org/ysnackbar-ios)  
_An easy-to-use UI component to display brief, transient messages to the user._

This framework allows you to add transient in-app messaging to your application. Multiple messages will stack using fluid animations. Messages can be fully themed and set to either expire after a specified time interval or to remain on-screen until dismissed.

![Snackbar demo animation](https://user-images.githubusercontent.com/1037520/221582361-e040414c-973b-4b14-9de8-645a11757471.gif)

Licensing
----------
Y—Snackbar is licensed under the [Apache 2.0 license](LICENSE).

Documentation
----------

Documentation is automatically generated from source code comments and rendered as a static website hosted via GitHub Pages at: https://yml-org.github.io/ysnackbar-ios/

Usage
----------

### Snack

A `Snack` is a model that represents a floating ephemeral alert or message to be presented to the user. It consists of the following:

- `alignment`: Alignment for the snack view. Default is `SnackbarManager.defaultAlignment`.
- `title`: Title for the snack view. This is an optional string and the default is nil.
- `message`: Message to be displayed by `SnackView`. This is of type `String`.
- `reuseIdentifier`: A string for identifying a snack. This is of type `String?` and the default is nil.
- `icon`: A small image to be displayed as part of the snack view. This is of type `UIImage?` and the default is nil.
- `duration`: The total duration for which the snack will be displayed. The default is 4 seconds.
- `appearance`: Sets the appearance of the `SnackView`. The default is `.default`.

Two snacks are said to be equal if either the `reuseIdentifier` of both snacks are equal or the `title` and `message` of both snacks are equal. This is made possible by the snack’s conformance to both `Equatable` and `Hashable`.

💡 If the snack `duration` is `.nan` or `.zero` then the snack lives forever (until you swipe to dismiss it)

### SnackView

A `SnackView` is a view that will be presented to the user through the `SnackbarManager`. The content of the view is populated using a `Snack` model object. It has one initializer:

- `init(snack: Snack)`
    - Initializes a `SnackView` using the `snack` data model.

Clients can modify or set the appearance of the `SnackView` while creating a `Snack` by setting the `appearance`. This will allow the client to modify the following properties:

- `title`:
    - A tuple consisting of `textColor` and `typography` for the title label.
    - Default is `(.label, .systemLabel.bold)` .
- `message`:
    - A tuple consisting of `textColor` and `typography` for the message label.
    - Default is `(.label, .systemLabel)` .
- `backgroundColor`:
    - Background color. The default is `systemBackground`.
- `borderColor`:
    - Border color. The default is `.label`.
- `borderWidth`:
    - Border width. The default is `0`.
- `elevation`:
    - Elevation (also known as box shadow). Default is `Appearance.elevation`.
- `layout`:
    - Layout properties such as spacing between views, corner radius. Default is `Layout()`.

**How to get `SnackView` from a `Snack`?**

```swift
func getSnackAssociatedView() -> SnackUpdatable
```

### SnackUpdatable

- Any object that can be updated with a new `Snack` model object.
- `SnackView` uses this to update an existing view with new information.

### SnackbarManager

All snacks are managed by the `SnackbarManager`.

#### State

- `defaultAlignment`
    - It is a global mutable shared state.
    - Describes the default alignment of the snack view.
    - Default is `.top`
    
#### Operations

- `class func add(snack: Snack)`
    - Creates a snack view using the snack passed as an argument to display a snack. 
    
    - Depending on the alignment, duplicate snacks will be updated and pushed to the bottom or top.

- `class func remove(snack: Snack)`
    - Removes a snack view using the snack passed as an argument. The `SnackContainerView` will be dismissed after the last snack is removed. 
    - There are 3 ways by which you can remove a snack. They are as follows:  
        - By calling `class func remove(snack: Snack)` operation.
        - When the snack has completed its `duration`
        - Swiping it up or down to dismiss.
    
Clients can control or modify the animation duration, spacing, etc of the `SnackbarManager` by setting the `appearance` property which is of type `SnackbarManager.Appearance`. This will allow the client to modify the following properties:

- `addAnimation`:
    - The animation to use when adding a snack.
    - The default is a spring animation with duration of 0.4
- `rearrangeAnimation`:
    - The animation to use when rearranging two or more snacks.
    - The default is an ease in, ease out animation with duration of 0.3
- `removeAnimation`:
    - The animation to use when removing a snack.
    - The default is an ease out animation with duration of 0.3
- `snackSpacing`:
    - Spacing between the snacks
    - The default is **16.0**
- `contentInset`:
    - The distance the content is inset from the superview.
    - The default is **16.0**
- `maxSnackWidth`:
    - Maximum width of a snack view. 
    - Helps to keep a fixed width for a snack view on an iPad screen.
    - The default is **428.0**
    
#### Default Features

Every snack added has the following default features:  

* corner radius based on appearance
* shadow based on appearance
* swipe enabled to dismiss snack view 

### Usage

1. **Importing the framework**
    
    ```swift
    import YSnackbar
    ```

2. **Create a snack**
    
    ```swift
    func makeSnack() -> Snack {
        Snack(
            alignment: .bottom,
            title: "Network Reachable",
            message: "You are currently online.",
            reuseIdentifier: "yml.co",
            icon: UIImage(named: "wifi"),
            duration: 8.0
          )
    }
    ```

3. **Add a snack**
    
    ```swift
    // Creates a snack using `SnackbarManager.defaultAlignment = .top` 
    let snack = Snack(message: "No network")

    // Adds to the top of the screen
    SnackbarManager.add(snack: snack) 
    ```
    
    ```swift
    // Creates a snack with bottom alignment
    let snack = Snack(alignment: .bottom, message: "Copied to clipboard")

    // Adds to the bottom of the screen
    SnackbarManager.add(snack: snack) 
    ```
    
    ```swift
    // Set `SnackbarManager.defaultAlignment` to bottom
    SnackbarManager.defaultAlignment = .bottom

    // Creates a snack using defaultAlignment.
    let snack = Snack(message: "Copied to clipboard")

    // Adds to the bottom of the screen
    SnackbarManager.add(snack: snack) 
    ```

4. **Remove a snack**
    
    ```swift
    let snack = Snack() 
    SnackbarManager.remove(snack)
    ```

5. **Create a custom Snack**
    
    ```swift
    final class ImageSnack: Snack {
        convenience init(named: String) {
            self.init(message: named, reuseIdentifier: "co.yml.page")
        }
    
        override func getSnackAssociatedView() -> SnackUpdatable {
            SnackImageView(snack: self)
        }
    }
    
    final class SnackImageView: UIImageView {
        private(set) var snack: Snack
    
        required init(snack: Snack) {
            self.snack = snack
            super.init(image: UIImage(named: snack.message))
            setUp()
        }
    
        required init?(coder: NSCoder) { nil }
    
        private func setUp() {
            self.contentMode = .scaleAspectFit
        }
    }
    
    extension SnackImageView: SnackUpdatable {
        func update(_ snack: Snack) {
            self.image = UIImage(named: snack.message)
            self.snack = snack
        }
    }
    ```

Dependencies
----------

Y—Snackbar depends upon our [Y—CoreUI](https://github.com/yml-org/ycoreui) and [Y—MatterType](https://github.com/yml-org/ymattertype) frameworks (both also open source and Apache 2.0 licensed).

Installation
----------

You can add Y—Snackbar to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Add Packages...**
2. Enter "[https://github.com/yml-org/ysnackbar-ios](https://github.com/yml-org/ysnackbar-ios)" into the package repository URL text field
3. Click **Add Package**

Contributing to Y—Snackbar
----------

### Requirements

#### SwiftLint (linter)
```
brew install swiftlint
```

#### Jazzy (documentation)
```
sudo gem install jazzy
```

### Setup

Clone the repo and open `Package.swift` in Xcode.

### Versioning strategy

We utilize [semantic versioning](https://semver.org).

```
{major}.{minor}.{patch}
```

e.g.

```
1.0.5
```

### Branching strategy

We utilize a simplified branching strategy for our frameworks.

* main (and development) branch is `main`
* both feature (and bugfix) branches branch off of `main`
* feature (and bugfix) branches are merged back into `main` as they are completed and approved.
* `main` gets tagged with an updated version # for each release
 
### Branch naming conventions:

```
feature/{ticket-number}-{short-description}
bugfix/{ticket-number}-{short-description}
```
e.g.
```
feature/CM-44-button
bugfix/CM-236-textview-color
```

### Pull Requests

Prior to submitting a pull request you should:

1. Compile and ensure there are no warnings and no errors.
2. Run all unit tests and confirm that everything passes.
3. Check unit test coverage and confirm that all new / modified code is fully covered.
4. Run `swiftlint` from the command line and confirm that there are no violations.
5. Run `jazzy` from the command line and confirm that you have 100% documentation coverage.
6. Consider using `git rebase -i HEAD~{commit-count}` to squash your last {commit-count} commits together into functional chunks.
7. If HEAD of the parent branch (typically `main`) has been updated since you created your branch, use `git rebase main` to rebase your branch.
    * _Never_ merge the parent branch into your branch.
    * _Always_ rebase your branch off of the parent branch.

When submitting a pull request:

* Use the [provided pull request template](.github/pull_request_template.md) and populate the Introduction, Purpose, and Scope fields at a minimum.
* If you're submitting before and after screenshots, movies, or GIF's, enter them in a two-column table so that they can be viewed side-by-side.

When merging a pull request:

* Make sure the branch is rebased (not merged) off of the latest HEAD from the parent branch. This keeps our git history easy to read and understand.
* Make sure the branch is deleted upon merge (should be automatic).

### Releasing new versions
* Tag the corresponding commit with the new version (e.g. `1.0.5`)
* Push the local tag to remote

Generating Documentation (via Jazzy)
----------

You can generate your own local set of documentation directly from the source code using the following command from Terminal:
```
jazzy
```
This generates a set of documentation under `/docs`. The default configuration is set in the default config file `.jazzy.yaml` file.

To view additional documentation options type:
```
jazzy --help
```
A GitHub Action automatically runs each time a commit is pushed to `main` that runs Jazzy to generate the documentation for our GitHub page at: https://yml-org.github.io/ysnackbar-ios/
