class UserWallet < ApplicationRecord
  belongs_to :user

  def self.add(other_user, amount)
    UserWallet.find_or_create_by(user: other_user)
    UserWallet
      .where(user: other_user)
      .update_all("balance = balance + #{amount}")
  end

  def self.minus(other_user, amount)
    UserWallet.find_or_create_by(user: other_user)
    UserWallet
      .where(user: other_user)
      .update_all("balance = balance - #{amount}")
  end
end
