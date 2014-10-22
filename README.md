# build_number

Creates a `.build_number` file in your current directory which will store and increment the `BUILD_NUMBER`
environment variable.  This is useful when you want to keep track of build numbers outside of a continuous integration
environment.

If the `BUILD_NUMBER` variable is already set, it will not be incremented.

## Installation

Add this line to your application's Gemfile:

    gem 'build_number'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install build_number

## Usage

In your project's Rakefile:

```ruby
require 'build_number'
BuildNumber.set_env

# ENV['BUILD_NUMBER'] is now set and incremented for the next build.
```

Alternatively, you can get the value directly.  In either case, the value will be incremented only
once per build.

```ruby
build_number = BuildNumber.current  # Reads the build number and increments the
                                    # value for the next build. Subsequent
                                    # calls return the same value.
```

You can also customize the name of the environment variable.

```ruby
BuildNumber.env_var_name = 'A_CUSTOM_ENV_VAR_NAME'
BuildNumber.set_env
```

If you want to read the next value of the build number without incrementing it, use the `next` method.

```ruby
next_build_number = BuildNumber.next
```

## Contributing

1. Fork it ( https://github.com/scardetto/build_number/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
