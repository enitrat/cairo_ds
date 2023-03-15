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
use serde::Serde;


const ZERO_USIZE: usize = 0_usize;

struct Stack<T> {
    items: DictFelt252To<felt252>,
    len: usize,
}

struct SquashedStack<T> {
    items: SquashedDictFelt252To<felt252>,
    len: usize,
}

impl SquashedStackDrop<T, impl TDrop: Drop::<T>> of Drop::<SquashedStack::<T>>;

trait StackTrait<T> {
    fn new() -> Stack<T>;
    fn push(ref self: Stack<T>, item: T) -> ();
    // fn pop(ref self: Stack<T>) -> Option<T>;
    // fn peek(ref self: Stack<T>) -> Option<T>;
    fn len(self: @Stack<T>) -> usize;
    fn is_empty(self: @Stack<T>) -> bool;
    fn squash(self: Stack<T>) -> SquashedStack<T>;
}

impl StackImpl<T, impl TDrop: Drop::<T>, impl TSerde: Serde::<T>> of StackTrait::<T> {
    #[inline(always)]
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Stack<T> {
        let items = DictFelt252ToTrait::<felt252>::new();
        Stack { items, len: 0_usize }
    }

    /// Pushes a new item onto the stack.
    /// Parameters
    /// * self The stack instance.
    /// * item The item to push onto the stack.
    fn push(ref self: Stack<T>, item: T) -> () {
        let Stack{mut items, mut len } = self;
        items.insert_type(stack_index: len, item: item);
        len = integer::u32_wrapping_add(len, 1_usize);
        self = Stack { items, len };
    }

    // /// Pops the top item off the stack.
    // /// Returns
    // /// * Option<T> The popped item, or None if the stack is empty.
    // fn pop(ref self: Stack<T>) -> Option<T> {
    //     let Stack{mut items, mut len } = self;
    //     match len == ZERO_USIZE {
    //         bool::False(_) => {
    //             len = integer::u32_wrapping_sub(len, 1_usize);
    //             let item = items.get(len.into());
    //             self = Stack { items, len };
    //             Option::Some(item)
    //         },
    //         bool::True(_) => {
    //             self = Stack { items, len };
    //             Option::None(())
    //         },
    //     }
    // }

    // /// Peeks at the top item on the stack.
    // /// Returns
    // /// * Option<T> The top item, or None if the stack is empty.
    // fn peek(ref self: Stack<T>) -> Option<T> {
    //     let Stack{mut items, len } = self;
    //     match len == ZERO_USIZE {
    //         bool::False(_) => {
    //             let item = items.get(integer::u32_wrapping_sub(len, 1_usize).into());
    //             self = Stack { items, len };
    //             Option::Some(item)
    //         },
    //         bool::True(_) => {
    //             self = Stack { items, len };
    //             Option::None(())
    //         },
    //     }
    // }

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

trait StackDictSerdeTrait<T> {
    // fn dict_len(ref self: Stack<T>) -> felt252;
    fn insert_type(ref self: DictFelt252To<felt252>, stack_index: usize, item: T) -> ();
// fn insert_loop(
//     ref self: DictFelt252To<felt252>,
//     serialized_items: @Array<felt252>,
//     dict_index: felt252,
//     remaining: usize
// ) -> ();
}

impl StackDictSerdeImpl<T,
impl TDrop: Drop::<T>,
impl TSerde: Serde::<T>> of StackDictSerdeTrait::<T> {
    fn insert_type(ref self: DictFelt252To<felt252>, stack_index: usize, item: T) {
        let mut serialized = ArrayTrait::new();
        Serde::<T>::serialize(ref serialized, item);
        let type_size: usize = serialized.len();
        let dict_index = integer::u64_to_felt252(integer::u32_wide_mul(stack_index, type_size));
    // insert_loop(ref self, @serialized, dict_index, type_size);
    }
}

//TODO recursive loop danglling reference error. update when fixed
fn insert_loop(
    ref self: DictFelt252To<felt252>,
    serialized_items: @Array<felt252>,
    index: felt252,
    remaining: usize
) { // // Check if out of gas.
// // TODO: Remove when automatically handled by compiler.
// match gas::get_gas() {
//     Option::Some(_) => {
//         if remaining == 0_usize {
//             return ();
//         } else {
//             let item_index = integer::u32_wrapping_sub(remaining, 1_usize);
//             let result: Option<@felt252> = serialized_items.get(item_index);
//             match result {
//                 Option::Some(item) => {
//                     let item = *item;
//                     self.insert(index, item);
//                     let new_remaining = integer::u32_wrapping_sub(remaining, 1_usize);
//                     insert_loop(ref self, serialized_items, index + 1, new_remaining);
//                 },
//                 Option::None(()) => {},
//             }
//         }
//     },
//     Option::None(_) => {
//         let mut data = ArrayTrait::new();
//         data.append('OOG');
//         self.squash();
//         panic(data);
//     }
// }
}
fn get_loop(
    ref self: DictFelt252To<felt252>,
    ref deserialized_items: Array<felt252>,
    index: felt252,
    remaining: usize
) {
    if remaining == 0_usize {
        return ();
    } else {
        let item_index = deserialized_items.len();
        let item = self.get(index + item_index.into());
        deserialized_items.append(item);
        get_loop(ref self, ref deserialized_items, index + 1, remaining - 1_usize);
    }
}
