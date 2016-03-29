class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  def remove
    if quantity > 1
      self.update_attribute(:quantity, quantity - 1)
    else
      self.destroy
    end
  end

  def total_price
    product.price * quantity
  end
end
