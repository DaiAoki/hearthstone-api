[![Build Status](https://travis-ci.org/DaiAoki/hearthstone-api.svg?branch=master)](https://travis-ci.org/DaiAoki/hearthstone-api)



# Hearthstone::Api
This is My favorite social card game 'Hearthstone' API client by pure Ruby with simple interface.
It covers all official endpoints. (Detail: [API Official Reference Page](https://develop.battle.net/documentation/api-reference/hearthstone-game-data-api))

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hearthstone-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hearthstone-api

## Usage
Before coding, you have to get client_id(= `YOUR_CLIENT_ID` ) and client_secret(= `YOUR_CLIENT_SECRET` ) in [Official Page](https://develop.battle.net).

```
# initialize client
client = Hearthstone::Api.new(
  {
    client_id: <YOUR_CLIENT_ID>,         # Required
    client_secret: <YOUR_CLIENT_SECRET>, # Required
    locale: "ja_JP",                     # Optionally, default: "en_US"
  }
)

# Card search
cards = client.search

# Fetch one card
card = client.fetch('52119-arch-villain-rafaam')

# Fetch deck
deck = client.deck("AAECAQcG+wyd8AKS+AKggAOblAPanQMMS6IE/web8wLR9QKD+wKe+wKz/AL1gAOXlAOalAOSnwMA")

# All metadata
metadata = client.metadata

# Specific metadata
sets = client.fetch_metadata("sets")
setGroups = client.fetch_metadata("setGroups")
types = client.fetch_metadata("types")
rarities = client.fetch_metadata("rarities")
classes = client.fetch_metadata("classes")
minionTypes = client.fetch_metadata("minionTypes")
keywords = client.fetch_metadata("keywords")
filterableFields = client.fetch_metadata("filterableFields")
numericFields = client.fetch_metadata("numericFields")
```

## Search Options
You can search by specifying conditions.

| option      | type    | description                                                                                                                                                                                             |
|:-----------:|:-------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| set         | string  | The slug of the set the card belongs to. If you do not supply a value, cards from all sets will be returned.                                                                                            |
| class       | string  | The slug of the card's class.                                                                                                                                                                           |
| manaCost    | numbers | The mana cost required to play the card. You can include multiple values in a comma-separated list of numeric values.                                                                                   |
| attack      | numbers | The attack power of the minion or weapon. You can include multiple values in a comma-separated list of numeric values.                                                                                  |
| health      | numbers | The health of a minion. You can include multiple values in a comma-separated list of numeric values.                                                                                                    |
| collectible | numbers | Whether a card is collectible. A value of 1 indicates that collectible cards should be returned; 0 indicates uncollectible cards. To return all cards, use a value of '0,1'.                            |
| rarity      | string  | The rarity of a card. This value must match the rarity slugs found in metadata.                                                                                                                         |
| type        | string  | The type of card (for example, minion, spell, and so on). This value must match the type slugs found in metadata.                                                                                       |
| minionType  | string  | The type of minion card (for example, beast, murloc, dragon, and so on). This value must match the minion type slugs found in metadata.                                                                 |
| keyword     | string  | A required keyword on the card (for example, battlecry, deathrattle, and so on). This value must match the keyword slugs found in metadata.                                                             |
| textFilter  | string  | A text string used to filter cards. You must include a locale along with the textFilter parameter.                                                                                                      |
| page        | number  | A page number.                                                                                                                                                                                          |
| pageSize    | number  | The number of results to choose per page. A value will be selected automatically if you do not supply a pageSize or if the pageSize is higher than the maximum allowed.                                 |
| sort        | string  | The field used to sort the results. Valid values include manaCost, attack, health, and name. Results are sorted by manaCost by default. Cards will also be sorted by class automatically in most cases. |
| order       | string  | The order in which to sort the results. Valid values are asc or desc. The default value is asc.                                                                                                         |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DaiAoki/hearthstone-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hearthstone::Api project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/DaiAoki/hearthstone-api/blob/master/CODE_OF_CONDUCT.md).
