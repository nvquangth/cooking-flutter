# cooking-flutter

API

**BASE_URL: https://gentle-fjord-54250.herokuapp.com**

- Get list category: 
> BASE_URL/category
- Get list recipe by category: 
> BASE_URL/category/{category_id}?limit={limit}&&offset={offset}
- Get recipe detail by id: 
> BASE_URL/recipe/{recipe_id}
- Search recipe by name
> BASE_URL/recipe?q={name}&?limit={limit}&&offset={offset}

**Example:**
> https://gentle-fjord-54250.herokuapp.com/category

> https://gentle-fjord-54250.herokuapp.com/category/5d67293df35b984e744868e0

> https://gentle-fjord-54250.herokuapp.com/category/5d67293df35b984e744868e0?limit=40

> https://gentle-fjord-54250.herokuapp.com/category/5d67293df35b984e744868e0?offset=15

> https://gentle-fjord-54250.herokuapp.com/category/5d67293df35b984e744868e0?limit=20&offset=10

> https://gentle-fjord-54250.herokuapp.com/recipe/5d6f2d0c89771377812fbad2

> https://gentle-fjord-54250.herokuapp.com/recipe?q=m%C3%A1t+ng%E1%BB%8Dt
