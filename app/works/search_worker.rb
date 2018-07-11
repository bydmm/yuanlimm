class SearchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'search'
  sidekiq_options retry: 0

  def perform(code)
    stock = Stock.find(code)
    fields = {
      code: stock.code,
      name: stock.name,
      tags: stock.tags
    }
    fields[:keyword] = fields.map { |_, v| v }.join(' ')
    puts fields
    client = OpenSearchPush.new(fields)
    puts client.push
  end
end
