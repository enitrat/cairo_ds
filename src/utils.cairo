use array::ArrayTrait;

//TODO use a snapshot here once bug fixed in the recursive function
/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array::<u256>` - The slice of the array.
fn array_slice<T, impl TCopy: Copy::<T>, impl TDrop: Drop::<T>>(
    ref src: Array::<T>, begin: usize, end: usize
) -> Array::<T> {
    let mut slice = ArrayTrait::<T>::new();
    fill_array(ref dst: slice, ref :src, index: begin, count: end);
    slice
}

/// * `dst` - The array to fill.
/// * `src` - The array to fill with.
/// * `index` - The index to start filling at.
/// * `count` - The number of elements to fill.
fn fill_array<T, impl TCopy: Copy::<T>, impl TDrop: Drop::<T>>(
    ref dst: Array::<T>, ref src: Array::<T>, index: u32, count: u32
) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::withdraw_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if count == 0_u32 {
        return ();
    }
    if index >= src.len() {
        return ();
    }
    let element = src.at(index);
    dst.append(*element);
    fill_array(ref dst, ref src, index + 1_u32, count - 1_u32)
}
