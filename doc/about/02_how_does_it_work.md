<!SLIDE  center>
# How Does It Work

* `parser` gem to create an Abstract Syntax Tree

<!SLIDE execute>

    @@@ Ruby
    require 'parser/current'
    puts Parser::CurrentRuby.parse("2 + 2")

<!SLIDE>

    @@@ Ruby
    puts File.read('lib/bad.rb')
    puts Parser::CurrentRuby.parse(File.read('lib/bad.rb'))
