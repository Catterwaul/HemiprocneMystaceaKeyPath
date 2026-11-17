import HMKeyPath
import Testing

enum KeyPath_Tests {
  @Test static func asClosure() {
    #expect(zip(1...5, 1...5).map((\(_, _).0).asClosure) == [1, 2, 3, 4, 5])
  }

  @Test static func accessors() {
    final class Cat { var mood = "😺" }
    let cat = Cat()
    let accessors = (\Cat.mood).accessors(cat)

    #expect(accessors.get() == "😺")
    accessors.set("😾")
    #expect(cat.mood == "😾")
  }

  @Test static func map() throws {
    #expect([("frisky", 3), ("buddy", 5)].map((\(_, _).0).map { $0.uppercased() }) == ["FRISKY", "BUDDY"])

    struct TransformError: Error, Equatable { }
    let transform = { (int: Int) throws(TransformError) -> Int in
      guard int > 0 else { throw TransformError() }
      return int
    }
    #expect(try [("🐈", 1)].map((\(_, _).1).map(transform)) == [1])
    #expect(throws: TransformError()) { try [("🐈", 0)].map((\(_, _).1).map(transform)) }

    #expect((\(_, _).1).map { NonCopyableInt($0 + 1) }(("🐈", 9)).value == 10)
  }
}
