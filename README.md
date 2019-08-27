# Kanzen - A Completeness Check Gem

### What is this?

This is a gem that gives you a sense of how complete a given model is. 

It checks a given model attributes, its relationships and its relationships' attributes and so on and so 
forth in order to check how complete it is. Keep in mind that queries are made against your DB during the
verification.

Keep in mind that it must be used alongside ActiveModel.

### When should I use this?

This gem is intended to basically give you a way of checking how complete a model is (e.g.: a user profile).

Say that you have an area of your application where a user fills their profile 
(or a handful of fields) and you want to show a progress bar related to how complete 
said user's profile is. Then this is for you.
 
By the way, that's what it was written for. I needed a way to check if a user's profile was complete
and I needed a way to know how complete it was. After writing the code to deal with that
I noticed that I would probably need to use it on different projects, so I decided to 
extract that logic and create this gem.

### What is this capable of doing?

Below is what's currently doable:
  - check if a given model (and its associations) are completely filled
  - return percentage values for present/missing attributes
  - return number of present/missing attributes
  - return a list of present/missing attributes (as hashes)

## Installation

### Instalation

Add the following to your Gemfile

``` ruby
gem 'kanzen'
```
Then run:

``` shell
bundle install
```

Prepend Kanzen to your model:

``` ruby
class Address < ApplicationRecord
  prepend Kanzen
  ...
end
```

## Usage

Given a model called Address...

... leaving one of its attributes as nil:

``` ruby
random_address = Address.new(street: 'Street Name', number: nil, street_number: 456)
puts random_address.completed? # prints false
```

... setting all of the attributes to something other than nil:

``` ruby
random_address = Address.new(street: 'Street Name', number: 123, street_number: 456)
puts random_address.completed? # prints true
```

A list containing fields to be ignored can also be passed:

``` ruby
random_address = Address.new(street: 'Street Name', number: nil, street_number: 456)

# prints true, because the number attribute is ignored.
puts random_address.completed?(ignore_list: [:number])
```

And a custom Proc can also be passed (so that you can customize what defines an attribute as
valid or invalid):

``` ruby
random_address = Address.new(street: "", number: 123, street_number: 456)

custom_proc = Proc.new do |value|
  if value.to_s == ""
    false
  else
    true
  end
end

# prints true, as all attributes are present
puts random_address.completed?

# prints false, because street.to_s equals "" and is evaluated as invalid according 
to the custom_proc passed
puts random_address.completed?(proc: custom_proc) 
``` 

### TO DO

- Write better tests
- Improve code quality 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/caws/kanzen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kanzen project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kanzen/blob/master/CODE_OF_CONDUCT.md).