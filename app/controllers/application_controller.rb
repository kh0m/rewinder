class ApplicationController < ActionController::API
  def main
    render status: 200
  end
end
