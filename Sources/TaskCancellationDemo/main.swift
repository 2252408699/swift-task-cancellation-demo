import Foundation

struct SearchResult: Sendable {
    let query: String
    let items: [String]
}

actor FakeSearchAPI {
    func search(_ query: String) async throws -> SearchResult {
        print("  API started: \(query)")
        for step in 1...5 {
            try await Task.sleep(for: .milliseconds(80))
            try Task.checkCancellation()
            print("  \(query): step \(step)/5")
        }
        print("  API finished: \(query)")
        return SearchResult(query: query, items: ["\(query)-1", "\(query)-2"])
    }
}

actor SearchModel {
    private let api: FakeSearchAPI
    private var currentTask: Task<Void, Never>?
    private(set) var visibleResults: SearchResult?

    init(api: FakeSearchAPI) { self.api = api }

    func submit(_ query: String) {
        currentTask?.cancel()
        let api = self.api

        currentTask = Task { [weak self] in
            do {
                let result = try await api.search(query)
                try Task.checkCancellation()
                await self?.commit(result)
            } catch is CancellationError {
                print("  Cancelled stale request: \(query)")
            } catch {
                print("  Request failed for \(query): \(error)")
            }
        }
    }

    private func commit(_ result: SearchResult) {
        visibleResults = result
        print("  UI committed: \(result.query)")
    }

    func waitForCurrentRequest() async {
        await currentTask?.value
    }
}

@main
struct Demo {
    static func main() async throws {
        let model = SearchModel(api: FakeSearchAPI())

        print("User types 'sw' and quickly changes it to 'swift':")
        await model.submit("sw")
        try await Task.sleep(for: .milliseconds(130))
        await model.submit("swift")
        await model.waitForCurrentRequest()

        let finalQuery = await model.visibleResults?.query ?? "none"
        print("Final visible query: \(finalQuery) (expected: swift)")
    }
}
