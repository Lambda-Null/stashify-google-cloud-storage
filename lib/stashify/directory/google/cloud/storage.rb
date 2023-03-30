# frozen_string_literal: true

require "stashify/directory"

require "stashify/file/google/cloud/storage"

module Stashify
  class Directory
    module Google
      module Cloud
        class Storage < Stashify::Directory
          attr_reader :bucket

          def initialize(bucket:, path:)
            @bucket = bucket
            super(path: path)
          end

          def write_file(file)
            @bucket.create_file(
              StringIO.new(file.contents),
              path_of(file.name),
            )
          end

          def delete_file(name)
            @bucket.file(path_of(name)).delete
          end

          def files
            @bucket.files.map do |gcloud_file|
              find(::Regexp.last_match(1)) if gcloud_file.name =~ %r{^#{Regexp.escape(path)}/([^/]*)(/.*)?$}
            end.compact
          end

          def ==(other)
            self.class == other.class && @bucket == other.bucket && path == other.path
          end

          private

          def directory?(name)
            path = path_of(name)
            !@bucket.file(path) && !@bucket.files(prefix: path).empty?
          end

          def directory(name)
            Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: path_of(name))
          end

          def file?(name)
            @bucket.file(path_of(name))
          end

          def file(name)
            Stashify::File::Google::Cloud::Storage.new(bucket: @bucket, path: path_of(name))
          end
        end
      end
    end
  end
end