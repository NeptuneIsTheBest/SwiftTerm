# Getting Started with SwiftTerm

Add a terminal emulator to your Swift application.

## Overview

SwiftTerm provides terminal emulation for macOS applications. This guide walks
through adding the dependency and embedding a terminal view.

## Adding SwiftTerm to Your Project

Add SwiftTerm as a Swift Package Manager dependency. In your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/migueldeicaza/SwiftTerm.git", from: "1.0.0")
]
```

Then add `"SwiftTerm"` to your target's dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftTerm"]
)
```

Or in Xcode, use **File > Add Package Dependencies** and enter the repository URL.

## macOS: Embedding a Local Terminal

The fastest way to get a working terminal on macOS is ``LocalProcessTerminalView``,
which connects the terminal to a local Unix process:

```swift
import SwiftTerm
import AppKit

class ViewController: NSViewController, LocalProcessTerminalViewDelegate {
    var terminalView: LocalProcessTerminalView!

    override func viewDidLoad() {
        super.viewDidLoad()

        terminalView = LocalProcessTerminalView(frame: view.bounds)
        terminalView.processDelegate = self
        terminalView.autoresizingMask = [.width, .height]
        view.addSubview(terminalView)

        terminalView.startProcess()
    }

    func sizeChanged(source: LocalProcessTerminalView, newCols: Int, newRows: Int) {}
    func setTerminalTitle(source: LocalProcessTerminalView, title: String) {
        view.window?.title = title
    }
    func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}
    func processTerminated(source: TerminalView, exitCode: Int32?) {
        // Handle process exit
    }
}
```

``LocalProcessTerminalView`` launches `/bin/bash` by default. Pass a different
executable and arguments to `startProcess(executable:args:environment:)` to run
other commands.

## macOS: Custom Data Source

If you need to connect the terminal to a custom data source (SSH, a network
socket, or a custom protocol), use ``TerminalView`` directly and implement
``TerminalViewDelegate``:

```swift
class MyTerminalController: NSViewController, TerminalViewDelegate {
    var terminalView: TerminalView!

    override func viewDidLoad() {
        super.viewDidLoad()
        terminalView = TerminalView(frame: view.bounds)
        terminalView.terminalDelegate = self
        view.addSubview(terminalView)
    }

    func send(source: TerminalView, data: ArraySlice<UInt8>) {
        // Send data to your backend (SSH channel, socket, etc.)
    }

    // Feed incoming data from the backend into the terminal:
    func onDataReceived(_ data: ArraySlice<UInt8>) {
        terminalView.feed(byteArray: data)
    }

    func sizeChanged(source: TerminalView, newCols: Int, newRows: Int) {}
    func setTerminalTitle(source: TerminalView, title: String) {}
    func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}
    func scrolled(source: TerminalView, position: Double) {}
    func requestOpenLink(source: TerminalView, link: String, params: [String: String]) {}
    func clipboardCopy(source: TerminalView, content: Data) {}
    func rangeChanged(source: TerminalView, startY: Int, endY: Int) {}
}
```

The key pattern is:
- Implement ``TerminalViewDelegate/send(source:data:)`` to forward user input
  to your backend.
- Call ``TerminalView/feed(byteArray:)`` when data arrives from the backend.
- Implement ``TerminalViewDelegate/requestOpenLink(source:link:params:)`` to
  control how link taps/clicks are handled.

## Headless: Scripting and Testing

``HeadlessTerminal`` runs a terminal emulator without any UI, useful for scripting
applications and inspecting terminal output programmatically:

```swift
import SwiftTerm

let semaphore = DispatchSemaphore(value: 0)

let headless = HeadlessTerminal(options: TerminalOptions.default) { exitCode in
    print("Process exited with code: \(exitCode ?? -1)")
    semaphore.signal()
}

headless.process.startProcess(executable: "/bin/ls", args: ["-la"])
semaphore.wait()

let output = headless.terminal.getBufferAsData()
print(String(data: output, encoding: .utf8) ?? "")
```

See <doc:HeadlessUsage> for more detail.

## Platform Availability

SwiftTerm is macOS-only. The package includes the core ``Terminal`` engine,
AppKit ``TerminalView``, Metal rendering, ``LocalProcess``, and
``HeadlessTerminal`` for macOS.

## Next Steps

- <doc:Customization> — Change fonts, colors, cursor style, and behavior
- <doc:GraphicsSupport> — Display inline images with Sixel, iTerm2, or Kitty
- <doc:SSHIntegration> — Connect the terminal to a remote host
