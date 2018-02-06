numbers = [1, 2, 3, 4, 5, 6]
even_numbers = numbers.select { |n| n.even? }
even_numbers

non_multiple_of_three = numbers.reject { |n| n % 3 == 0 }
non_multiple_of_three
