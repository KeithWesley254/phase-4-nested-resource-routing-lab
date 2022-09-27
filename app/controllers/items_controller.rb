class ItemsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
      return render json: items, include: :user
    end
    render json: items, except: [:created_at, :updated_at]
  end

  def show
    item = Item.find(params[:id])
    render json: item, except: [:created_at, :updated_at]
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(create_params)
    else
      item = Item.create(create_params)
      return render json: item, status: :created
    end
    render json: item, status: :created
  end

  private

  def create_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: { error: "Review not found" }, status: :not_found
  end

end
