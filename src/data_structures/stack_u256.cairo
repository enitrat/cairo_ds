//! Stack implementation.
//! # Example
//! ```
//! use cairo_ds::data_structures::stack_u256::StackTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StackTrait::new();
//! let val_1: u256 = 1.into();
//! let val_2: u256 = 1.into();

//! stack.push(val_1);
//! stack.push(val_2);

//! let value = stack.pop();
//! ```

// Core lib imports
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;

const ZERO_USIZE: usize = 0_usize;
const U32_MAX: u32 = 4294967295_u32;

struct Stack {
    items: Felt252Dict<u128>,
    len: usize,
}

// A squashed stack is a stack that whose dict has been squashed.
// A stack must be squashed before the program ends for soudness purposes.
struct SquashedStack {
    items: SquashedFelt252Dict<u128>,
    len: usize,
}

// SquashedStack can safely be dropped.
impl SquashedStackDrop of Drop::<SquashedStack>;
// impl U128Drop of Drop::<u128>;

impl DestructStack of Destruct::<Stack> {
    fn destruct(self: Stack) nopanic {
        self.items.squash();
    }
}


trait StackTrait {
    fn new() -> Stack;
    fn push(ref self: Stack, item: u256) -> ();
    fn pop(ref self: Stack) -> Option<u256>;
    fn peek(ref self: Stack) -> Option<u256>;
    fn len(self: @Stack) -> usize;
    fn is_empty(self: @Stack) -> bool;
}

impl StackImpl of StackTrait {
    //TODO report bug: inline new causes ap change error
    // #[inline(always)]
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Stack {
        let items = Felt252DictTrait::<u128>::new();
        Stack { items, len: 0_usize }
    }

    /// Pushes a new item onto the stack.
    /// Parameters
    /// * self The stack instance.
    /// * item The item to push onto the stack.
    fn push(ref self: Stack, item: u256) -> () {
        self.insert_u256(item);
        self.len += 1_usize;
    }

    /// Pops the top item off the stack.
    /// Returns
    /// * Option<u256> The popped item, or None if the stack is empty.
    fn pop(ref self: Stack) -> Option<u256> {
        if self.len() == 0_usize {
            Option::None(())
        } else {
            self.len -= 1_usize;
            self.peek_u256()
        }
    }

    /// Peeks at the top item on the stack.
    /// Returns
    /// * Option<u256> The top item, or None if the stack is empty.
    fn peek(ref self: Stack) -> Option<u256> {
        if self.len() == 0_usize {
            Option::None(())
        } else {
            self.peek_u256()
        }
    }

    /// Returns the length of the stack.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * usize The length of the stack.
    fn len(self: @Stack) -> usize {
        *self.len
    }

    /// Returns true if the stack is empty.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * bool True if the stack is empty, false otherwise.
    fn is_empty(self: @Stack) -> bool {
        *self.len == ZERO_USIZE
    }
}

trait StackU256HelperTrait {
    fn dict_len(ref self: Stack) -> felt252;
    fn insert_u256(ref self: Stack, item: u256) -> ();
    fn peek_u256(ref self: Stack) -> Option<u256>;
}

impl StackU256HelperImpl of StackU256HelperTrait {
    fn dict_len(ref self: Stack) -> felt252 {
        (self.len * 2_usize).into()
    }

    fn insert_u256(ref self: Stack, item: u256) {
        let dict_len: felt252 = self.dict_len();
        self.items.insert(dict_len, item.low);
        self.items.insert(dict_len + 1, item.high);
    }

    fn peek_u256(ref self: Stack) -> Option<u256> {
        if self.dict_len() == 0 {
            Option::None(())
        } else {
            let dict_len = (self.len * 2_usize).into();
            let high = self.items.get(dict_len - 1);
            let low = self.items.get(dict_len - 2);
            let item = u256 { low: low, high: high };
            Option::Some(item)
        }
    }
}
