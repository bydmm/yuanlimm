class StockOrder < ApplicationRecord
  enum status: %i[padding success cancel]

  serialize :detail, Hash

  belongs_to :stock, foreign_key: :stock_code
  belongs_to :user

  validates :stock, presence: true
  validates :user, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { only_integer: true }
  validates :finished_amount, presence: true, numericality: { only_integer: true }

  after_save :check_amount

  private

  def check_amount
    if status == 'padding' && finished_amount.abs >= amount.abs
      self.status = 'success'
      save
    end
  end
end
