require 'minitest/spec'
require 'minitest/autorun'
require "json"

class GiftIdea

  attr_accessor :title, :description

  def initialize(title,description)
    @title = title
    @description = description
  end

  class << self
    def search(term)
      file = File.read('data.json')
      gift_ideas_json_hash =  JSON.parse(file)
      gift_ideas_json_array = gift_ideas_json_hash['gift_ideas']
      gift_ideas = []
      search_results = []

      # create ruby object array from json array
      gift_ideas_json_array.each do |gift_idea|
        gift_ideas <<  GiftIdea.new(gift_idea['gift_idea']["title"], gift_idea['gift_idea']["description"])
      end

      # search from gift ideas object
      gift_ideas.each do |gift_idea|
        if search_criteria_is_satisfied?(gift_idea,term)
          search_results << gift_idea
        end
      end

      return search_results
    end

    def search_criteria_is_satisfied?(gift_idea_obj,keyword)
      # IMPORANT - convert title and description to string in case any of them is nil
      search_attributes = gift_idea_obj.title.to_s + gift_idea_obj.description.to_s
      search_attributes[/#{keyword}/i]
    end
  end
end

describe GiftIdea do
  let(:data) { File.read('data.json') }

  before do
    #
  end

  describe '.search' do
    it 'returns records which contain "Cake" in the title' do
      titles = GiftIdea.search('Cake').map(&:title)
      titles.must_include "3D Cake Moulds"
    end

    it 'returns records which contain "shoes" in the description' do
      descriptions = GiftIdea.search('shoes').map(&:description)
      descriptions.must_include "Great Shoes!"
    end
  end
end
