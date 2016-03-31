class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def self.as_csv  
    column_names = %w{name address email pay_type}
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << [item.name, item.address, item.email, item.pay_type].map(&:strip)
      end
    end
  end

end
