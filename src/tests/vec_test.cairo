// Core lib imports
use array::ArrayTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use result::ResultTrait;
use dict::DictFelt252ToTrait;

// Internal imports
use cairo_ds::data_structures::vec::VecTrait;

#[test]
#[available_gas(2000000)]
fn vec_new_test() {
    let mut vec = VecTrait::<u128>::new();
    let result_len = vec.len();
    let res = vec.squash();
    assert(result_len == 0_usize, 'vec length should be 0');
}

#[test]
#[available_gas(2000000)]
fn vec_len_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.len = 10_usize;
    let result_len = vec.len();
    vec.squash();
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
    vec.squash();
    assert(result_exists.unwrap() == 1_u128, 'vec get should return 1');
    assert(result_none.is_none(), 'vec get should return none');
}

//TODO dangling variable
// #[test]
// #[available_gas(2000000)]
// fn vec_at_test() {
//     let mut vec = VecTrait::<u128>::new();
//     vec.push(1_u128);
//     let result_exists = vec.at(0_usize);
//     let result_none = vec.at(1_usize);
//     vec.squash();
//     assert(result_exists == 1_u128, 'vec get should return 1');
//     assert(result_none == 0_u128, 'vec get should return 0');
// }

#[test]
#[available_gas(2000000)]
fn vec_push_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    let result_len = vec.len();
    vec.squash();
    assert(result_len == 1_usize, 'vec length should be 1');
}

#[test]
#[available_gas(2000000)]
fn vec_set_test() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    match vec.set(0_usize, 2_u128) {
        Result::Ok(_) => {
            let result = vec.get(0_usize);
            vec.squash();
            assert(result.unwrap() == 2_u128, 'vec get should return 2');
        },
        Result::Err(_) => {
            vec.squash();
            assert(false, 'vec set should not return error')
        }
    }
}

#[test]
#[available_gas(2000000)]
fn vec_set_test_expect_error() {
    let mut vec = VecTrait::<u128>::new();
    vec.push(1_u128);
    match vec.set(1_usize, 2_u128) {
        Result::Ok(_) => {
            vec.squash();
            assert(false, 'vec did not return error')
        },
        Result::Err(_) => {
            vec.squash();
            assert(true, 'vec dit return error')
        }
    }
}
