SpreeOrderConstraints
=====================

[![Coverage Status](https://coveralls.io/repos/nebulab/spree_order_constraints/badge.png)](https://coveralls.io/r/nebulab/spree_order_constraints)
[![Code Climate](https://codeclimate.com/github/nebulab/spree_order_constraints/badges/gpa.svg)](https://codeclimate.com/github/nebulab/spree_order_constraints)

This extension is a simple way to change the behaviour of `checkout_allowed?` to
add some constraints to your customers as they proceed to checkout.


Installation
------------

Add spree_order_constraints to your Gemfile:

```ruby
gem 'spree_order_constraints'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
./bin/rails g spree_order_constraints:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
./bin/rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_order_constraints/factories'
```

Copyright (c) 2014 Nebulab, released under the New BSD License
