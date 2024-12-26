require 'zru'

key = 'fd1e7e20a676'
secret = 'a88402f080b54547ad07114a13c1a375'

zru = ZRU::ZRUClient.new(key, secret)

# Create transaction
transaction = zru.transaction('currency' => 'EUR',
                               'products' => [{
                                                'amount' => 1,
                                                'product' => {
                                                  'name' => 'Product',
                                                  'price' => 5
                                                }
                               }])
transaction.save
transaction.pay_url # Send user to this url to pay
transaction.iframe_url # Use this url to show an iframe in your site

# Get plans
plans_paginator = zru.plan_resource.list
plans_paginator.count
plans_paginator.results # Application's plans
plans_paginator.next_list

# Get product, change and save
product = zru.product('id' => '59ba4752-1679-43b5-b0c7-2c48fdb77e4e')
product.retrieve
product.set('price', 10)
product.save

# Create and delete tax
tax = zru.tax('name' => 'Tax', 'percent' => 5)
tax.save
tax.delete

# Check if transaction was paid
transaction = zru.transaction('id' => 'c8325bb3-c24e-4c0c-b0ff-14fe89bf9f1f')
transaction.retrieve
transaction.status == 'D' # Paid

# Create subscription
subscription = zru.subscription('currency' => 'EUR',
                                 'plan' => {
                                   'name' => 'Plan',
                                   'price' => 5,
                                   'duration' => 1,
                                   'unit' => 'M',
                                   'recurring' => true
                                 },
                                 'note' => 'Note example'
)
subscription.save
subscription.pay_url # Send user to this url to pay
subscription.iframe_url # Use this url to show an iframe in your site

# Create authorization
authorization = zru.authorization('currency' => 'EUR')
authorization.save
authorization.pay_url # Send user to this url to pay
authorization.iframe_url # Use this url to show an iframe in your site

# Receive a notification
notification_data = zru.notification_data('status' => 'D', 'type' => 'P',
                                           'id' => 'c8325bb3-c24e-4c0c-b0ff-14fe89bf9f1f',
                                           'sale_id' => 'd1bb7082-7a97-48c6-893d-4d5febcd463b')
notification_data.is_status_done? # Paid

if notification_data.is_status_done?
  puts notification_data.is_status_done?
end

notification_data.is_status_expired? # Expired
notification_data.is_transaction?
notification_data.is_subscription?
notification_data.is_authorization?
notification_data.is_status_done?
notification_data.is_status_cancelled?
notification_data.is_status_expired?
notification_data.is_status_pending?
notification_data.check_signature

notification_data.transaction # Transaction Paid
notification_data.sale # Sale generated

# Exceptions

# Incorrect data
shipping = zru.shipping('name' => 'Normal shipping',
                         'price' => 19)# Price must be number
begin
  shipping.save
rescue ZRU::InvalidRequestError => e
  puts e.message # Status code of error
  puts e.json_body # Info from server
  puts e.resource # Resource used to make the server request
  puts e.resource_id # Resource id requested
end
