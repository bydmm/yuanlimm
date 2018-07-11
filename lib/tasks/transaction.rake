namespace :transaction do
  task clear: :environment do
    Transaction.where(pay_type: 'love')
               .where('created_at < ?', Time.now - 2.days)
               .delete_all
  end
end
