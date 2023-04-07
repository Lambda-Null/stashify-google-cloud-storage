# frozen_string_literal: true

require "stashify/directory"

require "stashify/file/google/cloud/storage"

module Stashify
  class Directory
    module Google
      module Cloud
        # An implementation for interacting with Google Cloud Storage
        # buckets as if they had directories with "/" as a path
        # separator. In addition to a path, it also needs a
        # Google::Cloud::Storage::Bucket object representing the
        # bucket the file resides within.
        class Storage < Stashify::Directory
          attr_reader :bucket

          def initialize(bucket:, path:)
            @bucket = bucket
            super(path: path)
          end

          def parent
            Stashify::Directory::Google::Cloud::Storage.new(
              bucket: @bucket,
              path: ::File.dirname(path),
            )
          end

          def files
            @bucket.files.map do |gcloud_file|
              find(::Regexp.last_match(1)) if gcloud_file.name =~ %r{^#{Regexp.escape(path)}/([^/]*)(/.*)?$}
            end.compact
          end

          def directory?(name)
            path = path_of(name)
            !@bucket.file(path) && !@bucket.files(prefix: path).empty?
          end

          def directory(name)
            Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: path_of(name))
          end

          def exists?(name)
            @bucket.file(path_of(name))
          end

          def file(name)
            Stashify::File::Google::Cloud::Storage.new(bucket: @bucket, path: path_of(name))
          end

          def ==(other)
            self.class == other.class && @bucket == other.bucket && path == other.path
          end
        end
      end
    end
  end
end
