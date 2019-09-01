require "faraday"
require "json"

module Hearthstone
  class Error < StandardError; end
  class InvalidClientError < Error; end

  class Api
    attr_reader :client_id, :client_secret, :region, :locale, :access_token, :is_valid

    OAUTH_URL = "https://us.battle.net/oauth/token"

    def initialize(options={})
      @client_id = options[:client_id]
      @client_secret = options[:client_secret]
      @region = options[:region] || "us"
      @locale = options[:locale] || "en_US"
      @access_token = get_token
      @is_valid = true
    rescue Hearthstone::InvalidClientError => e
      @is_valid = false
    end

    def endpoint
      @endpoint ||= Faraday::Connection.new(url: "https://#{region}.api.blizzard.com") do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Adapter::NetHttp
      end
    end

    def valid?
      is_valid
    end

    # Returns an up-to-date list of all cards matching the search criteria.
    # Allow Options
    #  - set[string]          : The slug of the set the card belongs to. If you do not supply a value, cards from all sets will be returned.
    #  - class[string]        : The slug of the card's class.
    #  - manaCost[numbers]    : The mana cost required to play the card. You can include multiple values in a comma-separated list of numeric values.
    #  - attack[numbers]      : The attack power of the minion or weapon. You can include multiple values in a comma-separated list of numeric values.
    #  - health[numbers]      : The health of a minion. You can include multiple values in a comma-separated list of numeric values.
    #  - collectible[numbers] : Whether a card is collectible. A value of 1 indicates that collectible cards should be returned; 0 indicates uncollectible cards.
    #                           To return all cards, use a value of '0,1'.
    #  - rarity[string]       : The rarity of a card. This value must match the rarity slugs found in metadata.
    #  - type[string]         : The type of card (for example, minion, spell, and so on). This value must match the type slugs found in metadata.
    #  - minionType[string]   : The type of minion card (for example, beast, murloc, dragon, and so on).
    #                           This value must match the minion type slugs found in metadata.
    #  - keyword[string]      : A required keyword on the card (for example, battlecry, deathrattle, and so on).
    #                           This value must match the keyword slugs found in metadata.
    #  - textFilter[string]   : A text string used to filter cards. You must include a locale along with the textFilter parameter.
    #  - page[number]         : A page number.
    #  - pageSize[number]     : The number of results to choose per page.
    #                           A value will be selected automatically if you do not supply a pageSize or if the pageSize is higher than the maximum allowed.
    #  - sort[string]         : The field used to sort the results. Valid values include manaCost, attack, health, and name.
    #                           Results are sorted by manaCost by default. Cards will also be sorted by class automatically in most cases.
    #  - order[string]        : The order in which to sort the results. Valid values are asc or desc. The default value is asc.
    def search(options={})
      request(:get, "/hearthstone/cards", localized_options(options))
    end

    # Returns the card with an ID or slug that matches the one you specify.
    # Allow Options
    #  - none
    def fetch(slug, options={})
      request(:get, "/hearthstone/cards/#{slug}", localized_options(options))
    end

    # Finds a deck by its deck code.
    # Allow Options
    #  - none
    def deck(deckcode, options={})
      request(:get, "/hearthstone/deck/#{deckcode}", localized_options(options))
    end

    # Returns information about the categorization of cards.
    # Metadata includes the card set, set group (for example, Standard or Year of the Dragon), rarity, class, card type, minion type, and keywords.
    def metadata(options={})
      request(:get, "/hearthstone/metadata", localized_options(options))
    end

    # Returns information about just one type of metadata.
    def fetch_metadata(type, options={})
      request(:get, "/hearthstone/metadata/#{type}", localized_options(options))
    end


    private

      def get_token
        con = Faraday::Connection.new(url: OAUTH_URL) do |builder|
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Adapter::NetHttp
        end
        res = con.get do |req|
          req.params[:grant_type] = 'client_credentials'
          req.params[:client_id] = client_id
          req.params[:client_secret] = client_secret
        end
        json = JSON.parse(res.body)
        if token = json["access_token"]
          token
        else
          raise Hearthstone::InvalidClientError
        end
      end

      def localized_options(options)
        options.merge(region: region, locale: locale)
      end

      def request(method, url, options={})
        case method
        when :get then get(url, options)
        when :post then post(url, options)
        when :put then put(url, options)
        when :delete then delete(url, options)
        end
      end

      def get(url, options={})
        res = endpoint.get do |req|
          req.url url
          req.params[:access_token] = access_token
          options.each{|k,v| req.params[k] = v} if options
          req.headers = {
            'Accept' => 'application/json',
          }
        end
        res.body.empty? ? {} : JSON.parse(res.body)
      end
  end
end
