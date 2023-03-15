//! Vec implementation.
//!
//! # Example
//! ```
//! use cairo_ds::data_structures::vec::VecTrait;
//!
//! // Create a new stack instance.
//! let mut vec = VecTrait::new();
//! ```

// Core lib imports
use dict::DictFelt252ToTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;

const ZERO_USIZE: usize = 0_usize;

struct Vec<T> {
    items: DictFelt252To<T>,
    len: usize,
}

struct SquashedVec<T> {
    items: SquashedDictFelt252To<T>,
    len: usize,
}

impl SquashedVecDrop<T, impl TDrop: Drop::<T>> of Drop::<SquashedVec::<T>>;

trait VecTrait<T> {
    fn new() -> Vec<T>;
    fn get(ref self: Vec<T>, index: usize) -> Option<T>;
    // fn at(ref self: Vec<T>, index: usize) -> T;
    fn push(ref self: Vec<T>, value: T) -> ();
    // fn set(ref self: Vec<T>, index: usize, value: T);
    fn set(ref self: Vec<T>, index: usize, value: T) -> Result<(), ()>;
    fn len(self: @Vec<T>) -> usize;
    fn squash(self: Vec<T>) -> SquashedVec<T>;
}

impl VecImpl<T, impl TDrop: Drop::<T>> of VecTrait::<T> {
    #[inline(always)]
    /// Creates a new Vec instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Vec<T> {
        vec_new()
    }

    /// Returns the item at the given index, or None if the index is out of bounds.
    /// Parameters
    /// * self The stack instance.
    /// * index The index of the item to get.
    /// Returns
    /// * Option<T> The item at the given index, or None if the index is out of bounds.
    fn get(ref self: Vec<T>, index: usize) -> Option<T> {
        let Vec{mut items, len } = self;
        if index < len {
            let item = items.get(index.into());
            self = Vec { items, len };
            Option::Some(item)
        } else {
            self = Vec { items, len };
            Option::None(())
        }
    }

    // TODO fix this dangling reference
    // /// Returns the item at the given index, or panics if the index is out of bounds.
    // /// Parameters
    // /// * self The stack instance.
    // /// * index The index of the item to get.
    // /// Returns
    // /// * T The item at the given index.
    // fn at(ref self: Vec<T>, index: usize) -> T {
    //     let Vec{mut items, len } = self;
    //     match index >= len {
    //         bool::False(_) => {
    //             let mut data = ArrayTrait::new();
    //             data.append('OOG');
    //             self = Vec { items, len };
    //             self.squash();
    //             panic(data)
    //         },
    //         bool::True(_) => {
    //             let item = items.get(index.into());
    //             self = Vec { items, len };
    //             item
    //         },
    //     }
    // }

    /// Pushes a new item to the vec.
    /// Parameters
    /// * self The vec instance.
    /// * value The value to push onto the vec.
    fn push(ref self: Vec<T>, value: T) -> () {
        let Vec{mut items, mut len } = self;
        items.insert(len.into(), value);
        len = integer::u32_wrapping_add(len, 1_usize);
        self = Vec { items, len };
    }

    //TODO fix this dangling reference
    // /// Sets the item at the given index to the given value.
    // /// Panics if the index is out of bounds.
    // /// Parameters
    // /// * self The vec instance.
    // /// * index The index of the item to set.
    // /// * value The value to set the item to.
    // fn set(ref self: Vec<T>, index: usize, value: T) {
    //     let Vec{mut items, len } = self;
    //     match index >= len {
    //         bool::False(_) => {
    //             let mut data = ArrayTrait::new();
    //             data.append('OOG');
    //             self = Vec { items, len };
    //             self.squash();
    //             panic(data);
    //         },
    //         bool::True(_) => {
    //             items.insert(index.into(), value);
    //             self = Vec { items, len };
    //         },
    //     }
    // }

    /// Sets the item at the given index to the given value.
    /// Panics if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to set.
    /// * value The value to set the item to.
    fn set(ref self: Vec<T>, index: usize, value: T) -> Result<(), ()> {
        let Vec{mut items, len } = self;
        debug::print_felt252(len.into());
        debug::print_felt252(index.into());
        match index < len {
            bool::False(_) => {
                self = Vec { items, len };
                Result::Err(())
            },
            bool::True(_) => {
                items.insert(index.into(), value);
                self = Vec { items, len };
                Result::Ok(())
            },
        }
    }

    /// Returns the length of the vec.
    /// Parameters
    /// * self The vec instance.
    /// Returns
    /// * usize The length of the vec.
    fn len(self: @Vec<T>) -> usize {
        *self.len
    }

    /// Squashes the dict of the vec.
    /// Dicts must be squashed after they're used for soundness purposes.
    /// Parameters
    /// * self The vec instance.
    /// Returns
    /// * SquashedVec<T> The vec with the squashed dict.
    fn squash(self: Vec<T>) -> SquashedVec<T> {
        let len = self.len();
        // we need to call the `len` method here to push the len to memory
        // otherwise we have a dangling reference error.
        let squashed_items = self.items.squash();
        SquashedVec { items: squashed_items, len: len }
    }
}

fn vec_new<T>() -> Vec<T> {
    let items = DictFelt252ToTrait::<T>::new();
    Vec { items, len: 0_usize }
}
