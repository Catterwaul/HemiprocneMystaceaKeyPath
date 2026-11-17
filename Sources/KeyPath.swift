public extension KeyPath {
  /// Convert this `KeyPath` to a partially-applied get accessor.
  ///
  /// This is the same as what the compiler can do for key path expressions,
  /// but extends the capability to named variables.
  @inlinable var asClosure: (Root) -> Value {
    { $0[keyPath: self] }
  }

  /// - Returns: A closure that returns a transformed `Value`.
  @inlinable func map<Transformed: ~Copyable, Error>(
    _ transform: @escaping (Value) throws(Error) -> Transformed
  ) -> (Root) throws(Error) -> Transformed {
    { try transform($0[keyPath: self]) }
  }
}

public extension ReferenceWritableKeyPath {
  /// Partially-applied `get` and `set` accessors for this key path.
  ///
  /// Typical usage: `accessors(root)`
  @inlinable var accessors: (Root) -> (
    get: () -> Value,
    set: (Value) -> Void
  ) {
    { root in
      ( get: { root[keyPath: self] },
        set: { root[keyPath: self] = $0 }
      )
    }
  }
}
