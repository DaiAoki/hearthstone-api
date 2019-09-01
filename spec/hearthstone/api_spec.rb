require "pry"
require "dotenv/load"

RSpec.describe Hearthstone::Api do
  it "has a version number" do
    expect(Hearthstone::VERSION).not_to be nil
  end

  let!(:client) {
    Hearthstone::Api.new(
      {
        client_id: ENV["CLIENT_ID"],
        client_secret: ENV["CLIENT_SECRET"],
        locale: "ja_JP",
      }
    )
  }

  context "when initialize" do
    context "when valid" do
      it "return access_token" do
        expect(client.access_token).to be_truthy
        expect(client.valid?).to be_truthy
      end
    end

    context "when invalid" do
      let!(:invalid_client) {
        Hearthstone::Api.new(
          {
            client_id: "invalid_client_id",
            client_secret: "invalid_client_secret",
            locale: "ja_JP",
          }
        )
      }

      it "is invalid" do
        expect(invalid_client.access_token).to be nil
        expect(invalid_client.valid?).to be_falsy
      end
    end
  end

  context "/hearthstone/cards" do
    context "#search" do
      let(:cards) { client.search }
      let(:paginate_cards) { client.search({page: 2, pageSize: 10}) }
      let(:five_mana_cards) { client.search({manaCost: 5}) }
      let(:over_ten_mana_cards) { client.search({manaCost: 10}) }

      it "returns card data" do
        expect(cards["cards"].count > 0).to be_truthy
      end

      it "return card data and page" do
        expect(paginate_cards["cards"].count).to eq 10
        expect(paginate_cards["page"]).to eq 2
      end

      it "returns 5 manaCost card data" do
        expect(five_mana_cards["cards"].all?{|card| card["manaCost"] == 5}).to be_truthy
      end

      it "return over 10 manaCost card data" do
        expect(over_ten_mana_cards["cards"].all?{|card| card["manaCost"] >= 10}).to be_truthy
      end
    end

    context "#fetch" do
      let(:cards) { client.search }
      let(:card) { cards["cards"].first }
      let(:result) { client.fetch(card["slug"]) }

      it "returns one card data" do
        expect(result["slug"]).to eq card["slug"]
      end
    end
  end

  context "/hearthstone/decks" do
    context "#deck" do
      let(:deck) { client.deck("AAECAQcG+wyd8AKS+AKggAOblAPanQMMS6IE/web8wLR9QKD+wKe+wKz/AL1gAOXlAOalAOSnwMA") }

      it "returns deck data" do
        expect(deck["cards"].count).to eq 30
      end
    end
  end

  context "/hearthstone/metadata" do
    let(:metadata) { client.metadata }

    context "#metadata" do
      it "return metadata" do
        expect(metadata["sets"].count > 0).to be_truthy
        expect(metadata["setGroups"].count > 0).to be_truthy
        expect(metadata["types"].count > 0).to be_truthy
        expect(metadata["rarities"].count > 0).to be_truthy
        expect(metadata["classes"].count > 0).to be_truthy
        expect(metadata["minionTypes"].count > 0).to be_truthy
        expect(metadata["keywords"].count > 0).to be_truthy
        expect(metadata["filterableFields"].count > 0).to be_truthy
        expect(metadata["numericFields"].count > 0).to be_truthy
      end
    end

    context "#fetch" do
      let(:sets) { client.fetch_metadata("sets") }
      let(:setGroups) { client.fetch_metadata("setGroups") }
      let(:types) { client.fetch_metadata("types") }
      let(:rarities) { client.fetch_metadata("rarities") }
      let(:classes) { client.fetch_metadata("classes") }
      let(:minionTypes) { client.fetch_metadata("minionTypes") }
      let(:keywords) { client.fetch_metadata("keywords") }
      let(:filterableFields) { client.fetch_metadata("filterableFields") }
      let(:numericFields) { client.fetch_metadata("numericFields") }

      it "return metadata" do
        expect(metadata["sets"]).to eq sets
        expect(metadata["setGroups"]).to eq setGroups
        expect(metadata["types"]).to eq types
        expect(metadata["rarities"]).to eq rarities
        expect(metadata["classes"]).to eq classes
        expect(metadata["minionTypes"]).to eq minionTypes
        expect(metadata["keywords"]).to eq keywords
        expect(metadata["filterableFields"]).to eq filterableFields
        expect(metadata["numericFields"]).to eq numericFields
      end
    end
  end
end
