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
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::Into;
use result::ResultTrait;
use array::ArrayTrait;

const ZERO_USIZE: usize = 0_usize;

struct Vec<T> {
    len: usize, 
}

impl VecDrop<T> of Drop::<Vec<T>>;


trait VecTrait<T> {
    fn new() -> Vec<T>;
    fn len(self: @Vec<T>) -> usize;
}

impl VecImpl<T, impl TDrop: Drop::<T>> of VecTrait::<T> {
    //TODO report inline(always) bug
    // #[inline(always)]
    /// Creates a new Vec instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Vec<T> {
        Vec { len: 0_usize }
    }


    /// Returns the length of the vec.
    /// Parameters
    /// * self The vec instance.
    /// Returns
    /// * usize The length of the vec.
    fn len(self: @Vec<T>) -> usize {
        //TODO pass by snapshot when bug fixed
        *(self.len)
    }
}

#[test]
fn test() {
    let mut vec = VecTrait::<usize>::new();
    vec.len = 10_usize;
    let result_len = vec.len();
    assert(result_len == 10_usize, 'vec length should be 10');
}
