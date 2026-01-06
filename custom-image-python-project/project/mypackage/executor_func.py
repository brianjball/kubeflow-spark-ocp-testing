def double_list(my_iterator):
    my_list = list(my_iterator)
    return iter(my_list + my_list)
