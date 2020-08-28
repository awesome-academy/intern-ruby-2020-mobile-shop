class CartsController < ApplicationController
  include CartsHelper

  before_action :declare, :check_exist, :create_sessions_cart,
                :update_sessions_cart, only: :create

  def index
    return unless session[:cart]

    @carts = Product.filter_by_ids(load_product_ids)
                    .includes :images
    @total = session[:cart].map do |item|
      item["quantity"].to_i * Product.find_by(id: item["product_id"]).price
    end.sum
  end

  def create
    render json: {
      sessions_length: session[:cart].length,
      total_item: @total_item,
      total: @total
    }
  end

  def update; end

  private

  def declare
    @exist = false
    @total_item = 0
    @total = 0
  end

  def check_exist
    session[:cart]&.each do |item|
      @exist = true if item["product_id"].to_i == params[:product_id].to_i
      product = Product.find_by id: item["product_id"]
      @total += product.price * item["quantity"]
    end
  end

  def create_sessions_cart
    return if @exist

    session[:cart] ||= []
    session[:cart].push(product_id: params[:product_id].to_i,
                        quantity: Settings.quantity_one)
  end

  # rubocop:disable Metrics/AbcSize

  def update_sessions_cart
    return unless @exist

    session[:cart].map do |item|
      next unless item["product_id"].to_i == params[:product_id].to_i

      product = Product.find_by id: params[:product_id]
      case params[:option]
      when "dec"
        @total -= product.price
        item["quantity"] -= 1 if item["quantity"] > 1
        @total_item = product.price * item["quantity"]
        session[:cart].delete(item) if item["quantity"] == 1
      when "inc"
        item["quantity"] = item["quantity"] + 1
        @total_item = product.price * item["quantity"]
        @total += product.price
      when "del"
        @total_item = product.price * item["quantity"]
        @total -= total_item
        session[:cart].delete(item)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def load_product_ids
    product_ids = []
    session[:cart].sort_by!{|k| k["product_id"].to_i}
    session[:cart].each{|item| product_ids << item["product_id"]}
    product_ids
  end

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end
end
