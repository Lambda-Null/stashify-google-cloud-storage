# Stashify::GoogleCloudStorage

This is an implementation of the [Stashify](https://rubydoc.info/gems/stashify) abstraction for Google Cloud Storage. It operates under the assumption that the "/" in file names has the typical meaning of a path separater.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stashify-google-cloud-storage'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install stashify-google-cloud-storage

## Usage

This implementation is built on top of an instance of `Google::Cloud::Storage::Bucket`. The following usage is an abbreviated form to illustrate how to engage in this particular library. For a more extensive example see [Stashify's Usage](https://rubydoc.info/gems/stashify#usage).

```ruby
> require "google/cloud/storage"
=> true
> storage = Google::Cloud::Storage.new(project_id: "some-project-id")
> bucket = storage.bucket("some-bucket-name")
> require "stashify/file/google/cloud/storage"
=> true
> file = Stashify::File::Google::Cloud::Storage.new(bucket: bucket, path: "pa
th/to/file")
=> 
#<Stashify::File::Google::Cloud::Storage:0x000055af8eb86800
...
> file.contents
=> "foo"
> require "stashify/directory/google/cloud/storage"
=> true
> dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: bucket, path: "path/to")
=> 
#<Stashify::Directory::Google::Cloud::Storage:0x000055af8ebd6918
...
> dir.find("file") == file
=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stashify-google_cloud_storage. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/stashify-google_cloud_storage/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stashify::GoogleCloudStorage project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stashify-google_cloud_storage/blob/main/CODE_OF_CONDUCT.md).
