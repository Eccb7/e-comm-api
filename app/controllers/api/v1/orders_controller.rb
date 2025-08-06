class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [ :show, :update, :destroy ]

  def index
    @orders = current_user.orders.includes(:order_items, :products).recent
    @orders = @orders.by_status(params[:status]) if params[:status].present?

    render json: @orders.as_json(
      include: {
        order_items: {
          include: :product
        }
      }
    )
  end

  def show
    render json: @order.as_json(
      include: {
        order_items: {
          include: :product
        }
      }
    )
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build(order_params)
      @order.status = "pending"

      if params[:order_items].present?
        params[:order_items].each do |item_params|
          product = Product.find(item_params[:product_id])

          # Check inventory
          unless product.can_fulfill?(item_params[:quantity].to_i)
            render json: {
              errors: [ "Product #{product.name} has insufficient inventory" ]
            }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end

          @order.order_items.build(
            product: product,
            quantity: item_params[:quantity],
            unit_price: product.price
          )
        end
      elsif params[:from_cart] == true
        # Create order from cart items
        current_user.cart_items.includes(:product).each do |cart_item|
          unless cart_item.product.can_fulfill?(cart_item.quantity)
            render json: {
              errors: [ "Product #{cart_item.product.name} has insufficient inventory" ]
            }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end

          @order.order_items.build(
            product: cart_item.product,
            quantity: cart_item.quantity,
            unit_price: cart_item.product.price
          )
        end
      end

      if @order.save
        # Update inventory
        @order.order_items.each do |item|
          item.product.decrement!(:inventory_count, item.quantity)
        end

        # Clear cart if order was created from cart
        current_user.cart_items.destroy_all if params[:from_cart] == true

        render json: @order.as_json(
          include: {
            order_items: {
              include: :product
            }
          }
        ), status: :created
      else
        render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    if @order.update(order_params.except(:total))
      render json: @order.as_json(
        include: {
          order_items: {
            include: :product
          }
        }
      )
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @order.can_be_cancelled?
      # Return inventory
      @order.order_items.each do |item|
        item.product.increment!(:inventory_count, item.quantity)
      end

      @order.update(status: "cancelled")
      head :no_content
    else
      render json: { errors: [ "Order cannot be cancelled" ] }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def current_user
    # Placeholder - implement authentication
    User.first || User.create!(
      email: "test@example.com",
      password: "password",
      first_name: "Test",
      last_name: "User"
    )
  end
end
