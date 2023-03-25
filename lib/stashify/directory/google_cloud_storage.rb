# frozen_string_literal: true

require "stashify/directory"

require "stashify/file/google_cloud_storage"

module Stashify
  class Directory
    class GoogleCloudStorage < Stashify::Directory
      attr_reader :bucket, :path

      def initialize(bucket, path)
        @bucket = bucket
        @path = path
        super(name: ::File.basename(path))
      end

      def ==(other)
        self.class == other.class && @bucket == other.bucket && @path == other.path
      end

      private

      def directory?(name)
        path = path_of(name)
        !@bucket.file(path) && !@bucket.files(prefix: path).empty?
      end

      def directory(name)
        Stashify::Directory::GoogleCloudStorage.new(@bucket, path_of(name))
      end

      def file(name)
        Stashify::File::GoogleCloudStorage.new(@bucket, path_of(name))
      end

      def path_of(name)
        ::File.join(@path, name)
      end
    end
  end
end