{% docs orders_status %}

### Order Status refers to the data standard [DS-1234](#)

Orders can be one of the following statuses:

| status         | description                                                                                                            |
|----------------|------------------------------------------------------------------------------------------------------------------------|
| placed         | The order has been placed but has not yet left the warehouse                                                           |
| shipped        | The order has ben shipped to the customer and is currently in transit                                                  |
| completed      | The order has been received by the customer                                                                            |
| return_pending | The customer has indicated that they would like to return the order, but it has not yet been received at the warehouse |
| returned       | The order has been returned by the customer and received at the warehouse                                              |


{% enddocs %}


{% docs customer_id %}

### Customer ID refers to the data standard [DS-2345](#)

Customer ID is the foreign key that refers to the id in the customers table.

![ERD](etc/jaffle_shop_erd.png)

{% enddocs %}