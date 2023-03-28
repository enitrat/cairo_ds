// Core lib imports
use array::ArrayTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use cairo_ds::data_structures::stack::StackTrait;
// Internal imports

#[test]
#[available_gas(2000000)]
fn stack_new_test() {
    let mut stack = StackTrait::<u256>::new();
    let result_len = stack.len();
    assert(result_len == 0_usize, 'stack length should be 0');
}
#[test]
#[available_gas(2000000)]
fn stack_is_empty_test() {
    let mut stack = StackTrait::<u256>::new();
    let result = stack.is_empty();

    assert(result == true, 'stack should be empty');
}
#[test]
#[available_gas(2000000)]
fn stack_push_test() {
    let mut stack = StackTrait::<u256>::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 2.into();

    stack.push(val_1);
    stack.push(val_2);

    let result_len = stack.len();
    let result_is_empty = stack.is_empty();

    assert(result_is_empty == false, 'must not be empty');
    assert(result_len == 2_usize, 'len should be 2');
}
#[test]
#[available_gas(2000000)]
fn stack_peek_test() {
    let mut stack = StackTrait::<u256>::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 2.into();

    stack.push(val_1);
    stack.push(val_2);
    match stack.peek() {
        Option::Some(result) => {
            assert(result == val_2, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return value');
        },
    };

    let result_len = stack.len();
    assert(result_len == 2_usize, 'should not remove items');
}

#[test]
// #[available_gas(2000000)]
fn stack_pop_test() {
    let mut stack = StackTrait::<u256>::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 2.into();

    stack.push(val_1);
    stack.push(val_2);
    let value = stack.pop();
    // TODO: bug variable dangling
    match value {
        Option::Some(result) => {
            assert(result == val_2, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return a value');
        },
    };
    let result_len = stack.len();
    assert(result_len == 1_usize, 'should remove item');
}
#[test]
#[available_gas(2000000)]
fn test_stack_u32() {
    let mut stack = StackTrait::<u32>::new();
    let val_1: u32 = 1.try_into().unwrap();
    let val_2: u32 = 2.try_into().unwrap();

    stack.push(val_1);
    stack.push(val_2);

    let result_len = stack.len();
    let result_is_empty = stack.is_empty();
    let stack_val_1 = stack.items.at(0_usize);

    assert(*stack_val_1 == val_1, 'wrong result');
    assert(result_is_empty == false, 'must not be empty');
    assert(result_len == 2_usize, 'len should be 2');

    let value = stack.pop();
    match value {
        Option::Some(result) => {
            assert(result == val_2, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return a value');
        },
    };

    let result_len = stack.len();
    assert(result_len == 1_usize, 'should remove item');
}

