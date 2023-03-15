// Core lib imports
use array::ArrayTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use cairo_ds::data_structures::stack_u256::StackTrait;
use cairo_ds::data_structures::stack_u256::U32_MAX;

use dict::DictFelt252ToTrait;
// Internal imports

#[test]
#[available_gas(2000000)]
fn stack_new_test() {
    let mut stack = StackTrait::new();
    let result_len = stack.len();
    stack.squash();
    assert(result_len == 0_usize, 'stack length should be 0');
}

#[test]
#[available_gas(2000000)]
fn stack_is_empty_test() {
    let mut stack = StackTrait::new();
    let result = stack.is_empty();
    stack.squash();
    assert(result == true, 'stack should be empty');
}

#[test]
#[available_gas(2000000)]
fn stack_push_test() {
    let mut stack = StackTrait::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 1.into();

    stack.push(val_1);
    stack.push(val_2);

    let result_len = stack.len();
    let result_is_empty = stack.is_empty();
    let low = stack.items.get(0);
    let high = stack.items.get(1);
    let stack_val_1 = u256 { low: low, high: high };
    stack.squash();
    assert(result_is_empty == false, 'must not be empty');
    assert(result_len == 2_usize, 'len should be 2');
    assert(stack_val_1 == val_1, 'wrong result');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('Max stack length reached', ))]
fn stack_push_u32_max_test() {
    let mut stack = StackTrait::new();
    stack.len = U32_MAX;
    let val_1: u256 = 1.into();
    stack.push(val_1);
    stack.squash();
}

#[test]
#[available_gas(2000000)]
fn stack_peek_test() {
    let mut stack = StackTrait::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 1.into();

    stack.push(val_1);
    stack.push(val_2);
    match stack.peek() {
        Option::Some(result) => {
            let result_len = stack.len();
            stack.squash();
            assert(result == val_2, 'wrong result');
            assert(result_len == 2_usize, 'should not remove items');
        },
        Option::None(_) => {
            stack.squash();
            assert(0 == 1, 'should return value');
        },
    };
}
#[test]
#[available_gas(2000000)]
fn stack_pop_test() {
    let mut stack = StackTrait::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 1.into();

    stack.push(val_1);
    stack.push(val_2);

    let value = stack.pop();
    match value {
        Option::Some(result) => {
            let result_len = stack.len();
            stack.squash();
            assert(result_len == 1_usize, 'should remove item');
            assert(result == val_2, 'wrong result');
        },
        Option::None(_) => {
            stack.squash();
            assert(0 == 1, 'should return a value');
        },
    };
}
