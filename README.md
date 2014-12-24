# StupidTest

A stupid, experimental clone of Minitest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stupid_test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stupid_test

## Usage

```ruby
# in dog_test.rb

require 'stupid_test'

class Dog
  def bark
    "miau"
  end

  def has_four_legs?
    true
  end

  def cat?
    true
  end
end

class DogTest < StupidTest::Test
  def test_bark_returns_wuff
    assert_equal "wuff", Dog.new.bark
  end

  def test_has_four_legs
    assert Dog.new.has_four_legs?
  end

  def test_dog_is_definitely_not_a_cat
    refute Dog.new.cat?, "Dog was a cat"
  end
end
```

`$ ruby dog_test.rb` then outputs:

```
F∙F

2/3 Tests failed:

lib/dog_test.rb:18:in `test_bark_returns_wuff':
  Expected: wuff
  Got:      miau

lib/dog_test.rb:26:in `test_dog_is_definitely_not_a_cat': Dog was a cat
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/stupid_test/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
