// Core lib imports
use array::ArrayTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use result::ResultTrait;
use dict::Felt252DictTrait;

// Internal imports
use cairo_ds::data_structures::vec::VecTrait;

#[test]
#[available_gas(2000000)]
fn vec_new_test() {
    let mut vec = VecTrait::<u128>::new();
    let result_len = vec.len();
    assert(result_len == 0_usize, 'vec length should be 0');
}
#[test]
#[available_gas(2000000)]
fn vec_len_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.len = 10_usize;
    let result_len = vec.len();
    assert(result_len == 10_usize, 'vec length should be 10');
}

#[test]
#[available_gas(2000000)]
fn vec_get_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.items.insert(0, 1_u128);
    vec.len = 1_usize;
    let result_exists = vec.get(0_usize);
    let result_none = vec.get(1_usize);
    assert(result_exists.unwrap() == 1_u128, 'vec get should return 1');
    assert(result_none.is_none(), 'vec get should return none');
}

#[test]
#[available_gas(2000000)]
fn vec_at_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    let result = vec.at(0_usize);
    assert(result == 1_u128, 'vec get should return 1');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('Index out of bounds', ))]
fn vec_at_out_of_bounds_test() {
    let mut vec = VecTrait::<u128>::new();
    let result = vec.at(0_usize);
}

#[test]
#[available_gas(2000000)]
fn vec_push_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    let result_len = vec.len();
    assert(result_len == 1_usize, 'vec length should be 1');
}
#[test]
#[available_gas(2000000)]
fn vec_set_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    vec.set(0_usize, 2_u128);
    let result = vec.get(0_usize);
    assert(result.unwrap() == 2_u128, 'vec get should return 2');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('Index out of bounds', ))]
fn vec_set_test_expect_error() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    vec.set(1_usize, 2_u128)
}

