# Google Analytics 4 integration for Spree Commerce

This is a Google Analytics 4 extension for [Spree Commerce](https://spreecommerce.org) - the [open-source eCommerce platform](https://spreecommerce.org) for [Rails](https://spreecommerce.org/category/ruby-on-rails/). 

This [Google Analytics 4 integration for Spree Commerce](https://spreecommerce.org/docs/integrations/analytics/google-analytics) allows you to track user behavior, sales performance, and marketing effectiveness across your store. 

With minimal setup required, you can gain valuable insights into how visitors interact with your site, which can help you make informed decisions to improve conversions, user experience, and overall business strategy.

> [!NOTE]
> To set up the Google Analytics integration, you must have a Google Analytics account and an associated property.

## Event Tracking

By default, the following events will be tracked in Google Analytics 4:
- page_view
- first_visit
- session_start
- user_engagement
- search
- add_payment_info
- add_shipping_info
- add_to_cart
- add_to_wishlist
- begin_checkout
- purchase
- remove_from_cart
- view_cart
- view_item

## Installation

1. Add this extension to your Gemfile with this line:

    ```ruby
    bundle add spree_google_analytics
    ```

2. Run the install generator

    ```ruby
    bundle exec rails g spree_google_analytics:install
    ```

3. Restart your server

  If your server was running, restart it so that it can find the assets properly.

## Setup

Please follow [our setup guide](https://spreecommerce.org/docs/integrations/analytics/google-analytics) to start tracking all events in Google Analytics dashboard.

## Developing

1. Create a dummy app

    ```bash
    bundle update
    bundle exec rake test_app
    ```

2. Add your new code
3. Run tests

    ```bash
    bundle exec rspec
    ```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_google_analytics/factories'
```

## Releasing a new version

```shell
bundle exec gem bump -p -t
bundle exec gem release
```

For more options please see [gem-release README](https://github.com/svenfuchs/gem-release)

## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

Copyright (c) 2025 [name of extension creator], released under the New BSD License

## Join the Community 

[Join our Slack](https://slack.spreecommerce.org) to meet other 6k+ community members and get some support.

## Need more support?

[Contact us](https://spreecommerce.org/contact/) for enterprise support and custom development services. We offer:
  * migrations and upgrades,
  * delivering your Spree application,
  * optimizing your Spree stack.

