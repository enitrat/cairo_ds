//! Stack implementation.
//!
//! In order to pop a value from the stack, the T type must implement the Copy trait.
//! # Example
//! ```
//! use cairo_ds::data_structures::stack::StackTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StackTrait::<u256>::new();
//! // Create an item and push it to the stack.
//! let mut item:u256 = 1.into();
//! stack.push(item);
//! Remove the item from the stack;
//! let item = stack.pop();
//! ```

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use cairo_ds::utils::array_slice;

const ZERO_USIZE: usize = 0_usize;


struct Stack<T> {
    items: Array<T>,
}

impl StackDrop<T, impl TDrop: Drop::<T>> of Drop::<Stack::<T>>;

trait StackTrait<T> {
    /// Creates a new Stack instance.
    fn new() -> Stack<T>;
    /// Pushes a new value onto the stack.
    fn push(ref self: Stack<T>, value: T);
    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    fn pop(ref self: Stack<T>) -> Option::<T>;
    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    fn peek(self: @Stack<T>) -> Option::<T>;
    /// Returns the number of items in the stack.
    fn len(self: @Stack<T>) -> usize;
    /// Returns true if the stack is empty.
    fn is_empty(self: @Stack<T>) -> bool;
}

impl StackImpl<T, impl TCopy: Copy::<T>, impl TDrop: Drop::<T>> of StackTrait::<T> {
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    #[inline(always)]
    fn new() -> Stack<T> {
        stack_new()
    }

    /// Pushes a new value onto the stack.
    /// * `self` - The stack to push the value onto.
    /// * `value` - The value to push onto the stack.
    fn push(ref self: Stack<T>, value: T) {
        let Stack{mut items } = self;
        items.append(value);
        self = Stack { items }
    }


    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    /// * `self` - The stack to pop the item off of.
    /// Returns
    /// * Stack The stack with the item removed.
    /// * Option::<T> The item removed or None if the stack is empty.
    fn pop(ref self: Stack<T>) -> Option::<T> {
        if self.is_empty() {
            return Option::None(());
        }
        // Deconstruct the stack struct because we consume it
        let Stack{items: mut items } = self;
        let stack_len = items.len();
        let last_idx = stack_len - 1_usize;

        let sliced_items = array_slice(ref items, begin: 0_usize, end: last_idx);

        let value = items.at(last_idx);
        // Update the returned stack with the sliced array
        self = Stack { items: sliced_items };
        Option::Some(*value)
    }

    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    /// * `self` - The stack to peek the item off of.
    /// Returns
    /// * Option::<T> The last item of the stack
    fn peek(self: @Stack<T>) -> Option::<T> {
        if self.is_empty() {
            return Option::None(());
        }
        Option::Some(*self.items.at(self.items.len() - 1_usize))
    }

    /// Returns the number of items in the stack.
    /// * `self` - The stack to get the length of.
    /// Returns
    /// * usize The number of items in the stack.
    fn len(self: @Stack<T>) -> usize {
        self.items.len()
    }

    /// Returns true if the stack is empty.
    /// * `self` - The stack to check if it is empty.
    /// Returns
    /// * bool True if the stack is empty, false otherwise.
    fn is_empty(self: @Stack<T>) -> bool {
        self.len() == ZERO_USIZE
    }
}

#[inline(always)]
fn stack_new<T>() -> Stack<T> {
    let mut items = ArrayTrait::<T>::new();
    Stack { items }
}
