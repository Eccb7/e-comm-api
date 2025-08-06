class Api::V1::CartItemsController < ApplicationController
  before_action :set_cart_item, only: [ :show, :update, :destroy ]

  def index
    @cart_items = current_user.cart_items.includes(:product)
    render json: @cart_items.as_json(include: :product)
  end

  def show
    render json: @cart_item.as_json(include: :product)
  end

  def create
    @cart_item = current_user.cart_items.find_by(product_id: cart_item_params[:product_id])

    if @cart_item
      @cart_item.quantity += cart_item_params[:quantity].to_i
      if @cart_item.save
        render json: @cart_item.as_json(include: :product), status: :ok
      else
        render json: { errors: @cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      @cart_item = current_user.cart_items.build(cart_item_params)
      if @cart_item.save
        render json: @cart_item.as_json(include: :product), status: :created
      else
        render json: { errors: @cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      render json: @cart_item.as_json(include: :product)
    else
      render json: { errors: @cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @cart_item.destroy
    head :no_content
  end

  def clear
    current_user.cart_items.destroy_all
    head :no_content
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
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
