# Selena: MVP Booking Flow

This document defines the single minimum business flow for Selena's local
development version.

## Core Flow

1. Create a user.
2. Create a hotel and a room.
3. Find an available room for selected dates.
4. Create a booking in `PENDING_PAYMENT` status and reserve the room.
5. Create a payment for the booking.
6. Confirm the booking when the payment succeeds.
7. Cancel the booking and release the room when the payment fails, is
   cancelled, or is refunded.

## Booking Lifecycle

```text
PENDING_PAYMENT -> CONFIRMED | CANCELLED
CONFIRMED       -> COMPLETED | CANCELLED
CANCELLED       -> terminal
COMPLETED       -> terminal
```

## Payment Lifecycle

```text
PENDING   -> SUCCEEDED | FAILED | CANCELLED
SUCCEEDED -> REFUNDED
FAILED    -> terminal
CANCELLED -> terminal
REFUNDED  -> terminal
```

## Dev MVP Scope

The following are out of scope for the dev MVP:

- authorization;
- OAuth;
- JWT;
- a real payment provider.

Payments use only a safe test stub. Card numbers, CVV values, and other real
payment credentials are neither accepted nor stored.
