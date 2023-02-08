require "multi_json"

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i # 7.json == (@id  = 7)

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def update(attrs)
        updates = {
          "submitter": attrs["submitter"],
          "quote": attrs["quote"],
          "attribution": attrs["attribution"],
        }.compact

        @hash = @hash.merge(updates)
      end

      def save
        File.open("db/quotes/#{@id}.json", "w") do |f|
          f << MultiJson.dump(@hash)
        end

        FileModel.new("db/quotes/#{@id}.json")
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new(f) }
      end

      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| File.split(f)[-1] }
        highest = names.map(&:to_i).max
        id = highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f << %{
            {
              "submitter": "#{hash["submitter"]}",
              "quote": "#{hash["quote"]}",
              "attribution": "#{hash["attribution"]}"
            }
          }
        end

        FileModel.new("db/quotes/#{id}.json")
      end
    end
  end
end
