# Swift Task Cancellation Demo

A runnable Swift 6 reproduction of a search-as-you-type screen. A slow request for an old query is cancelled before it can overwrite the newest UI state.

## Requirements

- macOS 13 or later
- Xcode 16 / Swift 6 or later

## Run

```bash
git clone https://github.com/2252408699/swift-task-cancellation-demo.git
cd swift-task-cancellation-demo
swift run
```

The output shows the `sw` request starting, being cancelled, and only the `swift` result being committed.
