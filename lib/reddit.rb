# rubocop:disable MethodLength,CyclomaticComplexity,AbcSize
def reddit_ruby_topics
  require 'json'

  json = JSON.parse(File.read('data/ruby.json'))

  filtered =
    if ARGV[0]
      json['data']['children'].select do |node|
        Regexp.new(ARGV[0]).match?(node['data']['title'])
      end
    else
      json['data']['children']
    end

  sorted = filtered.sort_by { |node| node['data']['score'] }

  sorted.each do |node|
    prefix = \
      case node['data']['score']
      when 0..5
        # Skip all low scoring posts
        next
      when 6..10
        '*'
      when 11..30
        '**'
      when 35..50
        '****'
      else
        '*****'
      end

    is_blog = /blog/.match?(node['data']['url'])
    is_medium = /medium\.com/.match?(node['data']['url'])
    str = prefix + ' ' + node['data']['title'] + ' from ' + node['data']['author'] # rubocop:disable Metrics/LineLength
    str = "\e[31m#{str}\e[0m" \
      if is_blog
    str = "\e[34m#{str}\e[0m" \
      if is_medium
    puts str
  end
end
# rubocop:enable MethodLength,CyclomaticComplexity,AbcSize

reddit_ruby_topics if $PROGRAM_NAME == __FILE__
