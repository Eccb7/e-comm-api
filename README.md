# E-Comm API

This is a Ruby on Rails API for a simple e-commerce platform. It provides backend services for managing products, categories, users, orders, and a shopping cart.

## Features

*   **Product Catalog:** Manage products, including name, description, price, and inventory.
*   **Categories:** Organize products into categories.
*   **User Management:** Basic user creation and management.
*   **Shopping Cart:** Add, update, remove, and clear items in a user's cart.
*   **Order Processing:** Create orders from cart items, manage order status, and handle inventory updates.
*   **API-Only:** Designed as a backend service for a frontend application.

## Technology Stack

*   **Backend:** Ruby on Rails 8
*   **Database:** PostgreSQL
*   **Ruby Version:** 3.3.0
*   **Web Server:** Puma
*   **Deployment:** Kamal & Docker

## Prerequisites

Before you begin, ensure you have the following installed:

*   Ruby 3.3.0 (it's recommended to use a version manager like `rbenv` or `rvm`)
*   Bundler
*   PostgreSQL

## Getting Started

Follow these steps to get your development environment set up:

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/Eccb7/e-comm-api.git
    cd e-comm-api
    ```

2.  **Install dependencies:**
    ```sh
    bundle install
    ```

3.  **Set up the database:**
    Create a `database.yml` file if you need to customize it, otherwise the default configuration will be used.
    ```sh
    # Create the development and test databases
    rails db:create

    # Run database migrations
    rails db:migrate
    ```

4.  **Seed the database:**
    Populate the database with sample data.
    ```sh
    rails db:seed
    ```

5.  **Start the Rails server:**
    ```sh
    bin/dev
    ```
    The API will be running at `http://localhost:3000`.

## API Endpoints

The API is versioned under `/api/v1`.

### Categories

| Method | Endpoint                  | Description              |
| :----- | :------------------------ | :----------------------- |
| `GET`  | `/api/v1/categories`      | Get all categories       |
| `GET`  | `/api/v1/categories/:id`  | Get a single category    |
| `POST` | `/api/v1/categories`      | Create a new category    |
| `PUT`  | `/api/v1/categories/:id`  | Update a category        |
| `DELETE`| `/api/v1/categories/:id`  | Delete a category        |

### Products

| Method | Endpoint                  | Description              |
| :----- | :------------------------ | :----------------------- |
| `GET`  | `/api/v1/products`        | Get all products (paginated) |
| `GET`  | `/api/v1/products/search` | Search for products      |
| `GET`  | `/api/v1/products/:id`    | Get a single product     |
| `POST` | `/api/v1/products`        | Create a new product     |
| `PUT`  | `/api/v1/products/:id`    | Update a product         |
| `DELETE`| `/api/v1/products/:id`    | Delete a product         |

### Users

| Method | Endpoint                  | Description              |
| :----- | :------------------------ | :----------------------- |
| `GET`  | `/api/v1/users`           | Get all users            |
| `GET`  | `/api/v1/users/:id`       | Get a single user        |
| `POST` | `/api/v1/users`           | Create a new user        |
| `PUT`  | `/api/v1/users/:id`       | Update a user            |
| `DELETE`| `/api/v1/users/:id`       | Delete a user            |

### Cart Items

| Method | Endpoint                  | Description              |
| :----- | :------------------------ | :----------------------- |
| `GET`  | `/api/v1/cart_items`      | Get all items in the cart|
| `POST` | `/api/v1/cart_items`      | Add an item to the cart  |
| `PUT`  | `/api/v1/cart_items/:id`  | Update a cart item       |
| `DELETE`| `/api/v1/cart_items/:id`  | Remove an item from the cart|
| `DELETE`| `/api/v1/cart_items/clear`| Clear all items from the cart|

### Orders

| Method | Endpoint                  | Description              |
| :----- | :------------------------ | :----------------------- |
| `GET`  | `/api/v1/orders`          | Get all orders for a user|
| `GET`  | `/api/v1/orders/:id`      | Get a single order       |
| `POST` | `/api/v1/orders`          | Create a new order       |
| `PATCH`| `/api/v1/orders/:id/cancel`| Cancel an order         |
| `DELETE`| `/api/v1/orders/:id`      | Delete an order          |

## Running the Test Suite

To run the tests, use the following command:

```sh
rails test
```

## Deployment

This application is configured for deployment using [Kamal](https://kamal-deploy.org/). The configuration can be found in [`config/deploy.yml`](config/deploy.yml) and the [`Dockerfile`](Dockerfile).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
