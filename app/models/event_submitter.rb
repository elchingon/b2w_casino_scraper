class EventSubmitter < ApiAccessor
  include MethodLogger # include the MethodLogger so we can easily log the returned response.
  logger_name "event_submit"
  # This class should do two things. Post Event data to the B2W API and successfully log the return.
  #initialize an instance of the ApiAccessor
  def initialize api_key=ENV['b2w_api_key'], api_url="http://api.born2win.local/v2/events"
    @api_url = api_url
    @api_key = api_key
  end

  def post_event event
    event_logger = logger("event_submit")
    begin
      event_json = event.as_json #to useable json object
      camel_event_json = event_json.transform_keys {|key| key.camelize(:lower)} #camelcase the keys for the PHP

      event_logger.info(camel_event_json)
      camel_event_json_nested = {"event" => camel_event_json, vId: 305} #nest it in event

      response = post_to_api(@api_url, :body => camel_event_json_nested) # post it to the the api

      event_logger.info("posting new event to b2w API with event id: #{event.id}") # log it just to make sure

      event_logger.info("The returned response status is #{response.inspect}") #log the response status

    rescue Exception => e
      logger.error(e.inspect) #log any errors
    end

  end

end