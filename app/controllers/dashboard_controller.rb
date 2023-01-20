class DashboardController < ApplicationController

  def index
    @products = ::Product.all
  end

  def create
    
    new_title = get_suggestion(params[:product][:ori_name])
    new_description = get_suggestion(params[:product][:ori_description])
    @product = ::Product.new(product_params)
    @product.name = new_title
    @product.description = new_description
    @product.save
    redirect_to products_path
  end

  private

    def product_params
        params.require(:product).permit(:ori_name, :ori_description)
    end

    def get_suggestion(word)
      api_key = ENV['AI21_API_KEY']
      uri = URI('https://api.ai21.com/studio/v1/experimental/rewrite')
      req = Net::HTTP::Post.new(uri)
      req.content_type = 'application/json'
      req['Authorization'] = "Bearer #{api_key}"

      # The object won't be serialized exactly like this
      # req.body = "{\n        \"text\": \"You can now use AI21 Studio to rewrite text.\",\n        \"intent\": \"general\"\n    }"
      req.body = {
        'text' => word,
        'intent' => 'general'
      }.to_json

      req_options = {
        use_ssl: uri.scheme == 'https'
      }
      res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(req)
      end
      result = JSON.parse(res.body)
      result = result["suggestions"]
      suggest = result.map { |s| s["text"] }
      suggest = suggest.join(", ")
    end
end


# api_key = "8FCXKAJVp75gdn8mvgU5zyyM2jQy5OpC"
      # body = '{
      #   "text": word,
      # }'
      # response = Faraday.post("https://api.ai21.com/studio/v1/experimental/rewrite") do |req|
      #   req.headers['Authorization'] = "Bearer #{api_key}"
      #   req.headers['Content-Type'] = "application/x-www-form-urlencoded"
      #   req.body = URI.encode_www_form(body)
      # end