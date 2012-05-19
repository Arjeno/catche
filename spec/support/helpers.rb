module RSpec
  module Helpers

    def dummy_controller(controller)
      controller  = controller.new
      request     = ActionController::TestRequest.new
      response    = ActionController::TestResponse.new

      controller.request  = @request
      controller.response = @response

      controller
    end

  end
end