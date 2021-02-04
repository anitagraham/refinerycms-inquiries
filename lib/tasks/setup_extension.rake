# namespace :refinery do
#   namespace :testing do
#     task :setup_extension do
#       require 'refinerycms-my-extension'
#       Refinery::MyEngineGenerator.start %w[--quiet]
#     end
#   end
# end
# Rake::Task['refinery:testing:setup_extension'].clear
namespace :refinery do
  namespace :testing do
    desc 'Setup configuration files for attachment testing'
    task :setup_extension do
      puts 'Running setup_extension task for Refinery::Inquiries'
      require 'refinerycms-inquiries'
      Refinery::InquiriesGenerator.start %w[--quiet]
      %w[
      config/storage.yml
      config/environments/test.rb
      config/initializers/refinery/inquiries.rb
    ]
    end

    desc 'Direct active storage uploads to a tmp directory'
    file 'config/storage.yml' => 'config/test.txt' do |file|
      puts "Running #{file.name}"
      config = {
        'test' => {
          'root' => "<%= Rails.root.join('tmp/storage') %>",
          'service' => "Disk"
        }
      }
      File.open(file.name, 'w') do |f|
        f.write config.to_yaml
      end
    end

    desc 'Ensure that active_storage uses the test configuration from storage.yml'
    file 'config/environments/test.rb' => 'config/test.txt' do |file|
      puts "Running #{file.name}"
      END_RE = /\A\s*end\s*\z/.freeze
      ADDED_LINE = "  config.active_storage.service = :test\n".freeze

      File.open(file.name, 'r') do |config|
        content = config.readlines
        insertion_point = find_last(content, END_RE)
        File.open("#{file.name}.new", 'w') do |new|
          content.each_with_index do |line, ix|
            new.write line
            new.write ADDED_LINE if ix == insertion_point
          end
        end
      end
      mv file.name, "#{file.name}.old"
      mv "#{file.name}.new", file.name
    end

    desc 'Setup configuration initial values'
    file 'config/initializers/refinery/inquiries.rb' => 'config/test.txt' do |file|
      puts "Running #{file.name}"
      File.open(file.name, 'w') do |f|
        f << <<-CONFIG
Refinery::Inquiries.configure do |config|
  config.documents_permitted = true
  config.documents_max_size = 3.megabytes
  config.documents_max_number = 3
  config.documents_permitted_types = ['image/jpg', 'image/jpeg', 'image/png']
end
        CONFIG
      end
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
