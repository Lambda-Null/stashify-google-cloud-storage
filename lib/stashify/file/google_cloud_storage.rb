# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    class GoogleCloudStorage < Stashify::File
      def initialize(bucket, path)
        @bucket = bucket
        @path = path
        super(name: ::File.basename(path))
      end

      def contents
        @bucket.file(@path).download.string
      end
    end
  end
end
