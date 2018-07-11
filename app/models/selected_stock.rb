class SelectedStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock, foreign_key: :stock_code
end
