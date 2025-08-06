class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :update, :destroy ]

  def index
    @products = Product.includes(:category)

    # Apply filters
    @products = @products.by_category(params[:category_id]) if params[:category_id].present?
    @products = @products.available if params[:available] == "true"
    @products = @products.price_range(params[:min_price], params[:max_price]) if params[:min_price] && params[:max_price]

    # Apply search
    if params[:search].present?
      @products = @products.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Pagination
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @products = @products.page(page).per(per_page)

    render json: {
      products: @products.as_json(include: :category),
      pagination: {
        current_page: @products.current_page,
        total_pages: @products.total_pages,
        total_count: @products.total_count
      }
    }
  end

  def show
    render json: @product.as_json(include: :category)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product.as_json(include: :category), status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product.as_json(include: :category)
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      head :no_content
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :inventory_count, :category_id)
  end
end
