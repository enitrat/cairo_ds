//! Stack implementation.
//! DOES NOT WORK WITH 
//! # Example
//! ```
//! use cairo_ds::data_structures::stack::StackTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StackTrait::new();
//! ```

// Core lib imports
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;

const ZERO_USIZE: usize = 0_usize;

struct Stack<T> {
    items: Felt252Dict<T>,
    len: usize,
}

struct SquashedStack<T> {
    items: SquashedFelt252Dict<T>,
    len: usize,
}

impl SquashedStackDrop<T, impl TDrop: Drop::<T>> of Drop::<SquashedStack::<T>>;

impl DestructStack<T, impl TDrop: Drop::<T>> of Destruct::<Stack<T>> {
    fn destruct(self: Stack<T>) nopanic {
        self.items.squash();
    }
}

trait StackTrait<T> {
    fn new() -> Stack<T>;
    fn push(ref self: Stack<T>, value: T) -> ();
    fn pop(ref self: Stack<T>) -> Option<T>;
    fn peek(ref self: Stack<T>) -> Option<T>;
    fn len(ref self: Stack<T>) -> usize;
    fn is_empty(ref self: Stack<T>) -> bool;
}

impl StackImpl<T, impl TDrop: Drop::<T>> of StackTrait::<T> {
    // #[inline(always)]
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Stack<T> {
        stack_new()
    }

    /// Pushes a new item onto the stack.
    /// Parameters
    /// * self The stack instance.
    /// * value The value to push onto the stack.
    fn push(ref self: Stack<T>, value: T) -> () {
        self.items.insert(self.len.into(), value);
        self.len += 1_usize;
    }

    /// Pops the top item off the stack.
    /// Returns
    /// * Option<T> The popped item, or None if the stack is empty.
    fn pop(ref self: Stack<T>) -> Option<T> {
        match self.len() == ZERO_USIZE {
            bool::False(_) => {
                let item = self.items.get(self.len.into() - 1);
                self.len = self.len - 1_usize;
                Option::Some(item)
            },
            bool::True(_) => {
                Option::None(())
            },
        }
    }

    /// Peeks at the top item on the stack.
    /// Returns
    /// * Option<T> The top item, or None if the stack is empty.
    fn peek(ref self: Stack<T>) -> Option<T> {
        match self.len() == ZERO_USIZE {
            bool::False(_) => {
                let item = self.items.get(self.len().into() - 1);
                Option::Some(item)
            },
            bool::True(_) => {
                Option::None(())
            },
        }
    }

    /// Returns the length of the stack.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * usize The length of the stack.
    fn len(ref self: Stack<T>) -> usize {
        //TODO use snapshot when bug solved
        self.len
    }

    /// Returns true if the stack is empty.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * bool True if the stack is empty, false otherwise.
    fn is_empty(ref self: Stack<T>) -> bool {
        self.len == ZERO_USIZE
    }
}

fn stack_new<T>() -> Stack<T> {
    let items = Felt252DictTrait::<T>::new();
    Stack { items, len: 0_usize }
}
