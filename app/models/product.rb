class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  mount_uploader :image_url, ImageUploader
  validates :title, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

  def self.latest
    Product.order(:updated_at).last
  end

  def self.as_csv  
    column_names = %w{title description price}  
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        # csv << item.attributes.values_at(*column_names).map(&:to_s).map(&:strip)
        csv << [item.title, item.description, item.price.to_s].map(&:strip)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      product_hash = row.to_hash # exclude the price field
      product = Product.where(title: product_hash["title"])

      if product.count == 1
        product.first.update_attributes(product_hash)
      else
        Product.create!(product_hash)
      end
    end
  end 

  private

    # ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end  
end
