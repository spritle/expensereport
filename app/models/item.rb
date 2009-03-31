class Item < ActiveRecord::Base
  def item_code_description
    item_code.to_s + ' (' + description + ')'
  end
end
