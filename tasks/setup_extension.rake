namespace :refinery do
  namespace :testing do

    END_RE = /\A\s*end\s*\z/.freeze
    tmpfile = 'tmp/touch.txt'

    desc 'Setup configuration files for attachment testing'
    task setup_extension: %w[
      prep
      config/storage.yml
      config/environments/test.rb
      config/environments/development.rb
      config/locales/en.yml
      cleanup
    ] do
        require 'refinerycms-inquiries'
        Refinery::InquiriesGenerator.start %w[--quiet]
        Rake::Task["config/initializers/refinery/inquiries.rb"].invoke
    end

    desc 'Preparation task. Create a new file to force config/env/test.rb task to run'
    task 'prep' do
      touch tmpfile
    end

    desc "Cleanup task. Cleanup after the prep task and everyone else has done their work"
    task 'cleanup' do
      rm tmpfile
    end

    desc 'Direct active storage uploads to a tmp directory'
    file 'config/storage.yml' do |file|
      config = {
        'test' => {
          'root' => "<%= Rails.root.join('tmp/storage') %>",
          'service' => "Disk"
        },
      }
      File.open(file.name, 'w') do |f|
        f.write config.to_yaml
      end
    end

    desc 'Ensure that active_storage uses the test configuration from storage.yml'
    file 'config/environments/test.rb': tmpfile do |file|
      new_line = "  config.active_storage.service = :test\n"
      insert_before_end(file.name, new_line)
    end

    desc 'Ensure that active_storage in spec/dummy, dev mode uses the test configuration from storage.yml'
    file 'config/environments/development.rb': tmpfile do |file|
      new_line = "  config.active_storage.service = :test\n"
      insert_before_end(file.name, new_line)
    end

    desc 'Setup configuration initial values'
    file 'config/initializers/refinery/inquiries.rb': [ 'prep', tmpfile ] do |file|
      test_settings = <<-SETTINGS
    # config values for testing
    config.attachments_permitted = true
    config.attachments_max_size = 100.kilobytes
    config.attachments_max_number = 1
    config.attachments_permitted_types = [ 'image/jpeg', 'image/png']
      SETTINGS
      insert_before_end(file.name, test_settings)
    end

    desc 'Add the error messages to the environment'
    file 'config/locales/en.yml': tmpfile do |file|
      cp "../../#{file.name}", file.name
    end

    def insert_before_end(filename, new_content)
      File.open(filename, 'r') do |oldfile|
        lines = oldfile.readlines
        insertion_point = find_last(lines, END_RE)

        File.open("#{filename}.new", 'w') do |new|
          lines.each_with_index do |line, ix|
            new.write new_content if ix == insertion_point
            new.write line
          end
        end
        mv filename, "#{filename}.old"
        mv "#{filename}.new", filename
        rm "#{filename}.old"
      end
    end

    def find_last(content = [], regex)
      ix = content.count
      loop do
        ix -= 1
        break if (content[ix] =~ regex) || ix < 0
      end
      return ix
    end
  end
end
Rake::Task['refinery:testing:setup_extension'].clear
