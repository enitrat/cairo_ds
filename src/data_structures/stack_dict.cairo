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
use dict::DictFelt252ToTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;

const ZERO_USIZE: usize = 0_usize;

struct Stack<T> {
    items: DictFelt252To<T>,
    len: usize,
}

struct SquashedStack<T> {
    items: SquashedDictFelt252To<T>,
    len: usize,
}

impl SquashedStackDrop<T, impl TDrop: Drop::<T>> of Drop::<SquashedStack::<T>>;

trait StackTrait<T> {
    fn new() -> Stack<T>;
    fn push(ref self: Stack<T>, value: T) -> ();
    fn pop(ref self: Stack<T>) -> Option<T>;
    fn peek(ref self: Stack<T>) -> Option<T>;
    fn len(self: @Stack<T>) -> usize;
    fn is_empty(self: @Stack<T>) -> bool;
    fn squash(self: Stack<T>) -> SquashedStack<T>;
}

impl StackImpl<T, impl TDrop: Drop::<T>> of StackTrait::<T> {
    #[inline(always)]
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
        let Stack{mut items, mut len } = self;
        items.insert(len.into(), value);
        len = integer::u32_wrapping_add(len, 1_usize);
        self = Stack { items, len };
    }

    /// Pops the top item off the stack.
    /// Returns
    /// * Option<T> The popped item, or None if the stack is empty.
    fn pop(ref self: Stack<T>) -> Option<T> {
        let Stack{mut items, mut len } = self;
        match len == ZERO_USIZE {
            bool::False(_) => {
                len = integer::u32_wrapping_sub(len, 1_usize);
                let item = items.get(len.into());
                self = Stack { items, len };
                Option::Some(item)
            },
            bool::True(_) => {
                self = Stack { items, len };
                Option::None(())
            },
        }
    }

    /// Peeks at the top item on the stack.
    /// Returns
    /// * Option<T> The top item, or None if the stack is empty.
    fn peek(ref self: Stack<T>) -> Option<T> {
        let Stack{mut items, len } = self;
        match len == ZERO_USIZE {
            bool::False(_) => {
                let item = items.get(integer::u32_wrapping_sub(len, 1_usize).into());
                self = Stack { items, len };
                Option::Some(item)
            },
            bool::True(_) => {
                self = Stack { items, len };
                Option::None(())
            },
        }
    }

    /// Returns the length of the stack.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * usize The length of the stack.
    fn len(self: @Stack<T>) -> usize {
        *self.len
    }

    /// Returns true if the stack is empty.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * bool True if the stack is empty, false otherwise.
    fn is_empty(self: @Stack<T>) -> bool {
        *self.len == ZERO_USIZE
    }

    /// Squashes the dict of the stack.
    /// Dicts must be squashed after they're used for soundness purposes.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * SquashedStack<T> The stack with the squashed dict.
    fn squash(self: Stack<T>) -> SquashedStack<T> {
        let len = self.len();
        //TODO FIXME
        // we need to call the `len` method here to push the len to memory
        // otherwise we have a dangling reference error.
        let squashed_items = self.items.squash();
        SquashedStack { items: squashed_items, len: len }
    }
}

fn stack_new<T>() -> Stack<T> {
    let items = DictFelt252ToTrait::<T>::new();
    Stack { items, len: 0_usize }
}
