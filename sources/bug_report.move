module bug_report::bug_report;

use sui::linked_table::{Self, LinkedTable};

/// This function has limit keys of 256kb
public fun get_keys<K: copy + drop + store, V: store>(linked_table: &LinkedTable<K, V>): vector<K> {
    let mut keys = vector::empty<K>();
    let mut option_key = linked_table.front();

    while (option_key.is_some()) {
        let key = *option_key.borrow();
        keys.push_back(key);
        option_key = linked_table.next(key);
    };

    return keys
}

// Tests ------------------------------------------------------------------------------------------
#[test]
fun get_keys_test() {
    let table = init_linked_table_test();

    assert!(get_keys(&table) ==  vector[1, 2, 3]);

    table.drop();
}

#[test_only]
fun init_linked_table_test(): LinkedTable<u64, u8> {
    let ctx = &mut tx_context::dummy();
    let mut table = linked_table::new<u64, u8>(ctx);

    table.push_back(1, 10);
    table.push_back(2, 20);
    table.push_back(3, 30);

    return table
}
