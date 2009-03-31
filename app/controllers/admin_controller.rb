class AdminController < ApplicationController
  def item
    @items = Item.find(:all)
  end

  def user
  end

end
