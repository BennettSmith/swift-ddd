/// A protocol that defines an aggregate root in Domain-Driven Design.
///
/// An aggregate root is a special type of entity that serves as the entry point to an aggregate,
/// which is a cluster of associated objects treated as a single unit for data changes.
/// It ensures the consistency of changes to the objects within its boundaries.
///
/// Aggregate roots are responsible for maintaining their invariants and publishing domain events
/// that occur within their aggregate boundary.
///
/// Example:
/// ```swift
/// struct Order: AggregateRoot {
///     let id: UUID
///     private(set) var items: [OrderItem]
///     private(set) var status: OrderStatus
///     private(set) var domainEvents: [OrderEvent] = []
///
///     mutating func addItem(_ item: OrderItem) {
///         items.append(item)
///         domainEvents.append(OrderEvent.itemAdded(item))
///     }
///
///     mutating func clearDomainEvents() {
///         domainEvents.removeAll()
///     }
/// }
/// ```
public protocol AggregateRoot: Entity {
    /// The type of domain events this aggregate root can emit.
    associatedtype Event: DomainEvent

    /// A collection of domain events that have occurred but haven't yet been processed.
    ///
    /// Domain events represent state changes or significant occurrences within the aggregate
    /// that other parts of the system might need to know about.
    var domainEvents: [Event] { get }

    /// Clears all pending domain events after they have been processed.
    ///
    /// This method should be called after the system has successfully processed and persisted
    /// all pending domain events.
    mutating func clearDomainEvents()
}

/// Default implementation for clearing domain events.
///
/// Concrete types should override this implementation to properly clear their domain events collection.
public extension AggregateRoot {
    mutating func clearDomainEvents() {
        // Implementation should be provided by concrete types
    }
} 