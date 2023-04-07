# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    module Google
      module Cloud
        # An implementation for interacting with files in Google Cloud
        # Storage buckets. The constructor needs an instance of
        # Google::Cloud::Storage::Bucket in order to know which bucket
        # to interact with.
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

          def exists?
            @bucket.file(path)
          end
        end
      end
    end
  end
end
