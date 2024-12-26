# ZRU Ruby


# Overview

ZRU Ruby provides integration access to the ZRU API.

# Installation

Add this line to your application's Gemfile:
```bash
    gem 'zru-ruby'
```    
And then execute:
```bash
    $ bundle
```
Or install it yourself as:
```bash
    gem install zru-ruby
```
# Quick Start Example

```ruby
    require 'zru'
    
    zru = ZRU::ZRUClient.new('KEY', 'SECRET_KEY')
    
    # Create transaction
    transaction = zru.transaction({
                                       'currency' => 'EUR',
                                       'products' => [{
                                                          'amount' => 1,
                                                          'product_id' => 'PRODUCT-ID'
                                                      }]
                                   })
    # or with product details
    transaction = zru.transaction({
                                       'currency' => 'EUR',
                                       'products' => [{
                                                          'amount' => 1,
                                                          'product' => {
                                                              'name' => 'Product',
                                                              'price' => 5
                                                          }
                                                      }]
                                   })
    transaction.save
    transaction.pay_url # Send user to this url to pay
    transaction.iframe_url # Use this url to show an iframe in your site

    # Get plans
    plans_paginator = zru.plan_resource.list
    plans_paginator.count
    plans_paginator.results # Application's plans
    plans_paginator.next_list
    
    # Get product, change and save
    product = zru.product({
                               'id' => 'PRODUCT-ID'
                           })
    product.retrieve
    product.set('price', 10)
    product.save
    
    # Create and delete tax
    tax = zru.tax({
                       'name' => 'Tax',
                       'percent' => 5
                   })
    tax.save
    tax.delete
    
    # Check if transaction was paid
    transaction = zru.transaction({
                                       'id' => 'TRANSACTION-ID'
                                   })
    transaction.retrieve
    transaction.status == 'D' # Paid
    
    # Create subscription
    subscription = zru.subscription({
                                         'currency' => 'EUR',
                                         'plan_id' => 'PLAN-ID',
                                         'note' => 'Note example'
                                     })
    # or with plan details
    subscription = zru.subscription({
                                         'currency' => 'EUR',
                                         'plan' => {
                                             'name' => 'Plan',
                                             'price' => 5,
                                             'duration' => 1,
                                             'unit' => 'M',
                                             'recurring' => true
                                         },
                                         'note' => 'Note example'
                                     })
    subscription.save
    subscription.pay_url # Send user to this url to pay
    subscription.iframe_url # Use this url to show an iframe in your site

    # Receive a notification
    notification_data = zru.notification_data(JSON_DICT_RECEIVED_FROM_MYCHOICE2PAY)
    notification_data.status == 'D' # Paid
    notification_data.transaction # Transaction Paid
    notification_data.sale # Sale generated

    # Exceptions
    require 'zru'
    
    # Incorrect data
    shipping = zru.shipping({
                                 'name' => 'Normal shipping',
                                 'price' => 'text' # Price must be number
                             })
    begin
      shipping.save
    rescue ZRU::InvalidRequestError => e
      puts e.message # Status code of error
      puts e.json_body # Info from server
      puts e.resource # Resource used to make the server request
      puts e.resource_id # Resource id requested
    end

```
