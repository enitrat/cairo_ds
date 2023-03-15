// Core lib imports
use array::ArrayTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use cairo_ds::data_structures::stack_dict::StackTrait;
use dict::DictFelt252ToTrait;
// Internal imports

#[test]
#[available_gas(2000000)]
fn stack_new_test() {
    let mut stack = StackTrait::<u128>::new();
    let result_len = stack.len();
    stack.squash();
    assert(result_len == 0_usize, 'stack length should be 0');
}
#[test]
#[available_gas(2000000)]
fn stack_is_empty_test() {
    let mut stack = StackTrait::<u128>::new();
    let result = stack.is_empty();
    stack.squash();
    assert(result == true, 'stack should be empty');
}

#[test]
#[available_gas(2000000)]
fn stack_push_test() {
    let mut stack = StackTrait::<u128>::new();
    let val_1: u128 = 1_u128;
    let val_2: u128 = 2_u128;

    stack.push(val_1);
    stack.push(val_2);

    let stack_val_1 = stack.items.get(0);

    let result_len = stack.len();
    let result_is_empty = stack.is_empty();
    stack.squash();
    // Asserts can panic and thus must be called after the squash.
    assert(stack_val_1 == val_1, 'wrong result');
    assert(result_is_empty == false, 'must not be empty');
    assert(result_len == 2_usize, 'len should be 2');
}
#[test]
#[available_gas(2000000)]
fn stack_peek_test() {
    let mut stack = StackTrait::<u128>::new();
    let val_1: u128 = 1_u128;
    let val_2: u128 = 2_u128;

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
    let mut stack = StackTrait::<u128>::new();
    let val_1: u128 = 1_u128;
    let val_2: u128 = 2_u128;

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
// // TODO: DictFeltTo only support u128 or felts?
// #[test]
// #[available_gas(2000000)]
// fn test_stack_u32() {
//     let mut stack = StackTrait::<u32>::new();
//     let val_1: u32 = 1.try_into().unwrap();
//     let val_2: u32 = 2.try_into().unwrap();

//     stack.push(val_1);
//     stack.push(val_2);
//     stack.squash();

//     let result_len = stack.len();
//     let result_is_empty = stack.is_empty();

//     let value = stack.pop();
//     match value {
//         Option::Some(result) => {
//             let result_len = stack.len();
//             stack.squash();
//             assert(result_is_empty == false, 'must not be empty');
//             assert(result_len == 2_usize, 'len should be 2');
//             assert(result_len == 1_usize, 'should remove item');
//             assert(result == val_2, 'wrong result');
//         },
//         Option::None(_) => {
//             stack.squash();
//             assert(result_is_empty == false, 'must not be empty');
//             assert(result_len == 2_usize, 'len should be 2');
//             assert(0 == 1, 'should return a value');
//         },
//     };
// }


