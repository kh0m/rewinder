require 'alexa_rubykit'
require 'json'

class ApplicationController < ActionController::API
  def main
    # Check that it's a valid Alexa request
    request_json = JSON.parse(request.body.read.to_s)
    # Creates a new Request object with the request parameter.
    request = AlexaRubykit.build_request(request_json)

    # We can capture Session details inside of request.
    # See session object for more information.
    session = request.session
    p session.new?
    p session.has_attributes?
    p session.session_id
    p session.user_defined?

    # We need a response object to respond to the Alexa.
    response = AlexaRubykit::Response.new

    # We can manipulate the request object.
    #
    p "request: #{request.to_s}"
    p "request id: #{request.request_id}"

    # Response
    # If it's a launch request
    if (request.type == 'LAUNCH_REQUEST')
      # Process your Launch Request
      # Call your methods for your application here that process your Launch Request.
      response.add_speech('Ruby running ready!')
      response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
    end

    if (request.type == 'INTENT_REQUEST')
      # Process your Intent Request
      p "slots: #{request.slots}"
      p "request name: #{request.name}"

      sentence = request.slots["sentence"]["value"]
      backwards_sentence = sentence.split(" ").reverse.join(" ")

      p "sentence: #{backwards_sentence}"
      response.add_speech(backwards_sentence)

      response.add_hash_card( { :title => 'Ruby Intent', :subtitle => "Intent #{request.name}" } )
    end

    if (request.type =='SESSION_ENDED_REQUEST')
      # Wrap up whatever we need to do.
      p "request type: #{request.type}"
      p "end reason: #{request.reason}"
      render status: 200
    end

    # Return response
    render json: response.build_response
  end
end
