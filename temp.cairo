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
    fn len(self: @Vec<T>) -> usize;
}

impl VecImpl<T, impl TDrop: Drop::<T>> of VecTrait::<T> {
    fn new() -> Vec<T> {
        vec_new()
    }

    fn len(self: @Vec<T>) -> usize {
        *(self.len)
    }
}

fn vec_new<T>() -> Vec<T> {
    let items = Felt252DictTrait::<T>::new();
    Vec { items, len: 0_usize }
}

#[test]
fn test() {
    let mut vec = VecTrait::<usize>::new();
    vec.len = 10_usize;
    let result_len = vec.len();
    assert(result_len == 10_usize, 'vec length should be 10');
}
