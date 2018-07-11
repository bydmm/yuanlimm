class CoinTransaction < Transaction
  after_save :change_user_wallet

  private

  def change_user_wallet
    UserWallet.add(payee, amount)
    UserWallet.minus(payer, amount)
  end
end
