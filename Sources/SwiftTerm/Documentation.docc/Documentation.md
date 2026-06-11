# ``SwiftTerm``

SwiftTerm is a VT100/Xterm terminal emulator library for Swift applications that
can be embedded into macOS AppKit applications, text-based headless tools, or
other macOS terminal scenarios.

## Overview

SwiftTerm provides a reusable, pluggable terminal emulation engine with an
AppKit front-end for macOS. The core engine handles escape sequence parsing,
buffer management, Unicode rendering, and terminal state, while the view layer
handles input, rendering, and macOS integration.

The library has been used in several commercially available SSH clients, including
[Secure Shellfish](https://apps.apple.com/us/app/secure-shellfish-ssh-files/id1336634154),
[La Terminal](https://apps.apple.com/us/app/la-terminal-ssh-client/id1629902861),
and [CodeEdit](https://github.com/CodeEditApp/CodeEdit).

SwiftTerm uses the Swift Package Manager for its build. Add the library to your
project by using the URL for this repository.

### macOS

The macOS AppKit ``TerminalView`` is a reusable `NSView` that can be connected to
any data source by implementing ``TerminalViewDelegate``. For the common case of
running a local Unix process, ``LocalProcessTerminalView`` connects the terminal
to a pseudo-terminal.

### Headless

``HeadlessTerminal`` runs a local process without any UI, useful for scripting,
testing, and screen-scraping terminal output.

### Features

- Unicode rendering including Emoji, combining characters, and grapheme clusters
- Colors: ANSI, 256-color, and TrueColor
- Text attributes: bold, italic, underline, strikethrough, dim/faint, blink, inverse
- Mouse event reporting (X10, SGR, UTF-8, URxvt protocols)
- Terminal resizing (local and remote-initiated)
- Hyperlink support (OSC 8)
- Configurable Apple view link tracking via ``LinkReporting`` (explicit OSC 8 and implicit URL detection)
- Optional GPU-accelerated rendering via Metal on macOS
- Graphics: Sixel, iTerm2-style inline images, and Kitty graphics protocol
- Selection and search with a built-in macOS find bar and programmable search APIs
- Thread-safe ``Terminal`` instances
- Terminal session recording and playback with `termcast`

## Topics

### Essentials

- <doc:GettingStarted>
- ``Terminal``
- ``TerminalOptions``
- ``CursorStyle``

### Views

- ``TerminalView``
- ``TerminalViewDelegate``

### Running Local Processes

- ``LocalProcess``
- ``LocalProcessDelegate``
- ``LocalProcessTerminalView``
- ``LocalProcessTerminalViewDelegate``

### Headless Usage

- <doc:HeadlessUsage>
- ``HeadlessTerminal``

### Guides

- <doc:Customization>
- <doc:GPURendering>
- <doc:GraphicsSupport>
- <doc:SSHIntegration>

### Terminal Delegate

- ``TerminalDelegate``

### Terminal Configuration

- ``TerminalOptions``
- ``CursorStyle``

### Buffer and Content Access

- ``Buffer``
- ``BufferLine``
- ``Terminal/BufferKind``

### Data Types

- ``Position``
- ``Attribute``
- ``CharData``
- ``CharacterStyle``
- ``Color``

### Selection and Search

- ``SelectionService``
- ``SearchService``
- ``SearchOptions``

### GPU Rendering

- ``MetalBufferingMode``
- ``MetalError``

### Graphics

- ``ImageSizeRequest``
- ``TerminalImage``

### Mouse Input

- ``Terminal/MouseMode``
