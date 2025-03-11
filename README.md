# SwiftDDD

A Swift package providing core building blocks for implementing Domain-Driven Design (DDD) patterns in your applications.

## Overview

This package provides the fundamental types needed to implement DDD tactical patterns in Swift:

- `ValueObject`: For modeling immutable objects defined by their attributes
- `Entity`: For modeling objects with distinct identity
- `AggregateRoot`: For modeling consistency boundaries and domain event generation
- `DomainEvent`: For modeling significant occurrences in your domain
- `Identifier`: For type-safe domain object identification

## Installation

Add this package to your project using Swift Package Manager by adding the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/BennettSmith/swift-ddd.git", from: "1.0.0")
]
```

## Usage Guide

### Value Objects

Use value objects when you need to model concepts that:
- Are defined by their attributes rather than identity
- Should be immutable
- Are conceptually whole (all properties together represent the concept)

```swift
struct Money: ValueObject {
    let amount: Decimal
    let currency: Currency
    
    func equals(_ other: Money) -> Bool {
        amount == other.amount && currency == other.currency
    }
}

struct Address: ValueObject {
    let street: String
    let city: String
    let postalCode: String
    let country: String
    
    func equals(_ other: Address) -> Bool {
        street == other.street &&
        city == other.city &&
        postalCode == other.postalCode &&
        country == other.country
    }
}
```

### Entities

Use entities when you need to model objects that:
- Have a distinct identity that persists across changes
- Need to be tracked or referenced individually
- May change state over time

```swift
struct Customer: Entity {
    typealias ID = Identifier<Customer>
    
    let id: ID
    var name: String
    var address: Address
    var preferredCurrency: Currency
    
    init(id: ID = ID(), name: String, address: Address, preferredCurrency: Currency) {
        self.id = id
        self.name = name
        self.address = address
        self.preferredCurrency = preferredCurrency
    }
}
```

### Aggregate Roots

Use aggregate roots when you need to:
- Ensure consistency across a group of related entities
- Maintain invariants across multiple objects
- Generate domain events for significant changes

```swift
struct Order: AggregateRoot {
    typealias ID = Identifier<Order>
    
    let id: ID
    private(set) var customer: Customer.ID
    private(set) var items: [OrderItem]
    private(set) var status: OrderStatus
    private(set) var domainEvents: [OrderEvent] = []
    
    mutating func addItem(_ item: OrderItem) {
        guard status == .draft else { return }
        items.append(item)
        domainEvents.append(OrderItemAddedEvent(orderId: id, item: item))
    }
    
    mutating func submit() {
        guard status == .draft, !items.isEmpty else { return }
        status = .submitted
        domainEvents.append(OrderSubmittedEvent(orderId: id))
    }
    
    mutating func clearDomainEvents() {
        domainEvents.removeAll()
    }
}
```

### Domain Events

Use domain events to:
- Record significant changes in your domain
- Enable loose coupling between different parts of your system
- Support audit trails and event sourcing

```swift
struct OrderSubmittedEvent: DomainEvent {
    typealias AggregateID = Order.ID
    
    let aggregateId: AggregateID
    let occurredOn: Date
    
    init(orderId: AggregateID) {
        self.aggregateId = orderId
        self.occurredOn = Date()
    }
}
```

### Best Practices

1. **Type-Safe Identifiers**
   - Always use the `Identifier<T>` type for entity IDs
   - Define a type alias in your entity for better readability
   ```swift
   typealias ID = Identifier<YourEntity>
   ```

2. **Value Object Immutability**
   - Make all properties `let` constants
   - Never expose mutable state
   - Implement value semantics through the `equals` method

3. **Aggregate Boundaries**
   - Keep aggregates small and focused
   - Reference other aggregates by ID only
   - Ensure all invariants can be enforced within the aggregate

4. **Domain Events**
   - Name events in past tense (e.g., `OrderSubmitted`, `PaymentProcessed`)
   - Include only relevant data in events
   - Clear events after they've been processed

5. **Encapsulation**
   - Use `private(set)` for mutable properties that should only be changed through methods
   - Make helper methods private if they're not part of the domain interface
   - Keep implementation details hidden

## Example Domain Model

Here's a complete example showing how these components work together:

```swift
// Value Objects
struct Money: ValueObject {
    let amount: Decimal
    let currency: Currency
    
    func equals(_ other: Money) -> Bool {
        amount == other.amount && currency == other.currency
    }
}

// Entities
struct OrderItem: Entity {
    typealias ID = Identifier<OrderItem>
    
    let id: ID
    let productId: String
    let quantity: Int
    let price: Money
}

// Aggregate Root
struct Order: AggregateRoot {
    typealias ID = Identifier<Order>
    
    let id: ID
    private(set) var customerId: Customer.ID
    private(set) var items: [OrderItem]
    private(set) var status: OrderStatus
    private(set) var total: Money
    private(set) var domainEvents: [OrderEvent] = []
    
    mutating func addItem(_ item: OrderItem) {
        guard status == .draft else { return }
        items.append(item)
        recalculateTotal()
        domainEvents.append(OrderItemAddedEvent(orderId: id, item: item))
    }
    
    private mutating func recalculateTotal() {
        total = items.reduce(Money(amount: 0, currency: .usd)) { result, item in
            Money(amount: result.amount + item.price.amount, currency: result.currency)
        }
    }
}

// Domain Events
struct OrderItemAddedEvent: DomainEvent {
    typealias AggregateID = Order.ID
    
    let aggregateId: AggregateID
    let occurredOn: Date
    let item: OrderItem
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.