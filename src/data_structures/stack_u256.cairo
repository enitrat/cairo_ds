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
use dict::DictFelt252ToTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;

const ZERO_USIZE: usize = 0_usize;
const U32_MAX: u32 = 4294967295_u32;

struct Stack {
    items: DictFelt252To<u128>,
    len: usize,
}

// A squashed stack is a stack that whose dict has been squashed.
// A stack must be squashed before the program ends for soudness purposes.
struct SquashedStack {
    items: SquashedDictFelt252To<u128>,
    len: usize,
}

// SquashedStack can safely be dropped.
impl SquashedStackDrop of Drop::<SquashedStack>;

trait StackTrait {
    fn new() -> Stack;
    fn push(ref self: Stack, item: u256) -> ();
    fn pop(ref self: Stack) -> Option<u256>;
    fn peek(ref self: Stack) -> Option<u256>;
    fn len(self: @Stack) -> usize;
    fn is_empty(self: @Stack) -> bool;
    fn squash(self: Stack) -> SquashedStack;
}

impl StackImpl of StackTrait {
    #[inline(always)]
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Stack {
        let items = DictFelt252ToTrait::<u128>::new();
        Stack { items, len: 0_usize }
    }

    /// Pushes a new item onto the stack.
    /// Parameters
    /// * self The stack instance.
    /// * item The item to push onto the stack.
    fn push(ref self: Stack, item: u256) -> () {
        self.insert_u256(item);
        let Stack{mut items, mut len } = self;
        match len == U32_MAX {
            bool::False(_) => {
                // We can't use the panickable version because it would require some kind of explicit destructor to drop the stack on a panic.
                let new_len = integer::u32_wrapping_add(len, 1_usize);
                self = Stack { items, len: new_len };
            },
            bool::True(_) => {
                let mut data = ArrayTrait::new();
                data.append('Max stack length reached');
                self = Stack { items, len: len };
                self.squash();
                panic(data)
            }
        }
    }

    /// Pops the top item off the stack.
    /// Returns
    /// * Option<u256> The popped item, or None if the stack is empty.
    fn pop(ref self: Stack) -> Option<u256> {
        let Stack{mut items, mut len } = self;
        match len == ZERO_USIZE {
            bool::False(_) => {
                self = Stack { items, len };
                let item = self.get_u256();
                let Stack{mut items, mut len } = self;
                let new_len = integer::u32_wrapping_sub(len, 1_usize);
                self = Stack { items, len: new_len };
                item
            },
            bool::True(_) => {
                self = Stack { items, len };
                Option::None(())
            },
        }
    }

    /// Peeks at the top item on the stack.
    /// Returns
    /// * Option<u256> The top item, or None if the stack is empty.
    fn peek(ref self: Stack) -> Option<u256> {
        let Stack{mut items, len } = self;
        match len == ZERO_USIZE {
            bool::False(_) => {
                self = Stack { items, len };
                let item = self.get_u256();
                item
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

    /// Squashes the dict of the stack.
    /// Dicts must be squashed after they're used for soundness purposes.
    /// Parameters
    /// * self The stack instance.
    /// Returns
    /// * SquashedStack The stack with the squashed dict.
    fn squash(self: Stack) -> SquashedStack {
        let len = self.len();
        //TODO FIXME
        // we need to call the `len` method here to push the len to memory
        // otherwise we have a dangling reference error.
        let squashed_items = self.items.squash();
        SquashedStack { items: squashed_items, len: len }
    }
}

trait StackU256HelperTrait {
    fn dict_len(ref self: Stack) -> felt252;
    fn insert_u256(ref self: Stack, item: u256) -> ();
    fn get_u256(ref self: Stack) -> Option<u256>;
}

impl StackU256HelperImpl of StackU256HelperTrait {
    #[inline(always)]
    fn dict_len(ref self: Stack) -> felt252 {
        // Explicitly use un-panickable function.
        // This assumes that self.len() is less than 2^32, which is true because we only allow up 2^32 items on the stack with the `push` method.
        // We can't use the panickable version because it would require some kind of explicit destructor to drop the stack.
        integer::u64_to_felt252(integer::u32_wide_mul(self.len(), 2_usize))
    }

    fn insert_u256(ref self: Stack, item: u256) {
        let dict_len: felt252 = self.dict_len();
        self.items.insert(dict_len, item.low);
        self.items.insert(dict_len + 1, item.high);
    }

    fn get_u256(ref self: Stack) -> Option<u256> {
        let dict_len: felt252 = self.dict_len();
        if dict_len == 0 {
            Option::None(())
        } else {
            let high = self.items.get(dict_len - 1);
            let low = self.items.get(dict_len - 2);
            let item = u256 { low: low, high: high };
            Option::Some(item)
        }
    }
}
