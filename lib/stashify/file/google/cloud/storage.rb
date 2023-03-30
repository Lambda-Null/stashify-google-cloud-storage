# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    module Google
      module Cloud
        class Storage < Stashify::File
          def initialize(bucket:, path:)
            @bucket = bucket
            super(path: path)
          end

          def contents
            @bucket.file(path).download.string
          end

          def write(contents)
            @bucket.create_file(
              StringIO.new(contents),
              path,
            )
          end

          def delete
            @bucket.file(path).delete
          end
        end
      end
    end
  end
end
