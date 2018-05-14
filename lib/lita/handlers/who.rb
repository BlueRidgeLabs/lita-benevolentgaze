require 'httparty'
module Lita
  module Handlers
    class Who < Handler

      route(/^invite <@([^>]+)>/i, :invite_kiosk, help:{
        "invite"=>'send you the kiosk invite link for the user mentioned'
      })

      route(/^who|list/i, :who, help: {
        "who" => "lists all of the people currently at 150 Court."
      })

      def invite_kiosk(response)
        response.reply_privately "Invitation link: https://office.brl.nyc/slack_me_up/#{response.matches[0][0]} "
      end

      def who(response)
        request = HTTParty.get 'https://office.brl.nyc/currently_in_office.json'
        names = request.parsed_response['people'].map{ |person| person['name'] }.uniq
        response.reply "Currently in the office:#{names.join("
        ")}
        Register your devices here: https://office.brl.nyc/register"
      end
    end
    Lita.register_handler(Who)
  end
end
