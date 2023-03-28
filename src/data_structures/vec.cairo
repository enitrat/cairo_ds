//! Vec implementation.
//!
//! # Example
//! ```
//! use cairo_ds::data_structures::vec::VecTrait;
//!
//! // Create a new stack instance.
//! let mut vec = VecTrait::<u128>::new();
//! // Push some items onto the stack.
//! vec.push(1_u128);
//! vec.push(2_u128);
//! // Pop some items off the stack
//! let pop_result:Option<u128> = vec.pop();
//! ...
//! ```

// Core lib imports
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;


struct Vec<T> {
    items: Felt252Dict<T>,
    len: usize,
}

impl DestructVec<T, impl TDrop: Drop::<T>> of Destruct::<Vec<T>> {
    fn destruct(self: Vec<T>) nopanic {
        self.items.squash();
    }
}


trait VecTrait<T> {
    fn new() -> Vec<T>;
    fn get(ref self: Vec<T>, index: usize) -> Option<T>;
    fn at(ref self: Vec<T>, index: usize) -> T;
    fn push(ref self: Vec<T>, value: T) -> ();
    fn set(ref self: Vec<T>, index: usize, value: T);
    fn len(self: @Vec<T>) -> usize;
}

impl VecImpl<T, impl TDrop: Drop::<T>> of VecTrait::<T> {
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
        if index < self.len() {
            let item = self.items.get(index.into());
            Option::Some(item)
        } else {
            Option::None(())
        }
    }

    /// Returns the item at the given index, or panics if the index is out of bounds.
    /// Parameters
    /// * self The stack instance.
    /// * index The index of the item to get.
    /// Returns
    /// * T The item at the given index.
    fn at(ref self: Vec<T>, index: usize) -> T {
        if index < self.len() {
            let item = self.items.get(index.into());
            item
        } else {
            let mut data = ArrayTrait::new();
            data.append('Index out of bounds');
            panic(data)
        }
    }

    /// Pushes a new item to the vec.
    /// Parameters
    /// * self The vec instance.
    /// * value The value to push onto the vec.
    fn push(ref self: Vec<T>, value: T) -> () {
        self.items.insert(self.len.into(), value);
        self.len = integer::u32_wrapping_add(self.len, 1_usize);
    }

    /// Sets the item at the given index to the given value.
    /// Panics if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to set.
    /// * value The value to set the item to.
    fn set(ref self: Vec<T>, index: usize, value: T) {
        if index < self.len() {
            self.items.insert(index.into(), value);
        } else {
            let mut data = ArrayTrait::new();
            data.append('Index out of bounds');
            panic(data);
        }
    }

    /// Returns the length of the vec.
    /// Parameters
    /// * self The vec instance.
    /// Returns
    /// * usize The length of the vec.
    fn len(self: @Vec<T>) -> usize {
        *(self.len)
    }
}

fn vec_new<T>() -> Vec<T> {
    let items = Felt252DictTrait::<T>::new();
    Vec { items, len: 0_usize }
}
