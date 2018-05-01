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

    blog = /medium\.com|blog/.match?(node['data']['title'])

    puts(
      prefix + ' ' + (blog ? '[BLOG] ' : '') +
      node['data']['title'] +
      ' from ' + node['data']['author']
    )
  end
end
# rubocop:enable MethodLength,CyclomaticComplexity,AbcSize

reddit_ruby_topics if $PROGRAM_NAME == __FILE__
