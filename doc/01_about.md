<!SLIDE   subsection>
# Rubocop #

### Rob Di Marco - 5/1/2018 - philly.rb

    Role models are important
      -- Officer Alex J. Murphy / RoboCop

<!SLIDE >
# Rubocop is...

* Static Code Analysis
* Best Practice Enforcer
* A Guide Towards Better Ruby

<!SLIDE>
# Installation / Running

* Install gem (`gem install` or `bundle install`)
* Run `rubocop` from command line
* Install in your favorite text editor

<!SLIDE>
# How It Works

* `parser` to create an Abstract Syntax Tree from Ruby files
* __Cops__ define matching rules, violation documentation, and (sometimes) auto-correct
* Cops are organized in to __departments__

<!SLIDE>
# [Boolean Symbol](https://github.com/bbatsov/rubocop/blob/master/lib/rubocop/cop/lint/boolean_symbol.rb)
    @@@ Ruby
    class BooleanSymbol < Cop
      MSG = 'Symbol with a boolean name - ' \
            'you probably meant to use `%<boolean>s`.'.freeze

      def_node_matcher :boolean_symbol?, '(sym {:true :false})'

      def on_sym(node)
        return unless boolean_symbol?(node)

        add_offense(node, message: format(MSG, boolean: node.value))
      end
    end

<!SLIDE>
# Cop In Action

    @@@ Console

    > cat lib/boolean_symbol.rb
    if :false
      puts 1
    else
      puts true
    end
    >
    > be ruby-parse  lib/boolean_symbol.rb
    (if
      (sym :false)
      (send nil :puts
        (int 1))
      (send nil :puts
        (true)))
    >
    > be rubocop lib/boolean_symbol.rb


<!SLIDE>
# [BigDecimal New](https://github.com/bbatsov/rubocop/blob/master/lib/rubocop/cop/lint/big_decimal_new.rb)

    @@@ Ruby
    class BigDecimalNew < Cop
      MSG = '`%<double_colon>sBigDecimal.new()` is deprecated. ' \
            'Use `%<double_colon>sBigDecimal()` instead.'.freeze

      def_node_matcher :big_decimal_new, <<-PATTERN
        (send
          (const ${nil? cbase} :BigDecimal) :new ...)
      PATTERN

      def on_send(node)
        return unless big_decimal_new(node) do |captured_value|
          double_colon = captured_value ? '::' : ''
          message = format(MSG, double_colon: double_colon)

          add_offense(node, location: :selector, message: message)
        end
      end

      def autocorrect(node)
        lambda do |corrector|
          corrector.remove(node.loc.selector)
          corrector.remove(node.loc.dot)
        end
      end
    end

<!SLIDE>
# Cop In Action

    @@@ Console
    > cat lib/big_decimal.rb
    _d = BigDecimal.new(123.456, 3)
    >
    > be ruby-parse  lib/big_decimal.rb
    (lvasgn :_d
      (send
        (const nil :BigDecimal) :new
        (float 123.456)
        (int 3)))
    >
    > be rubocop lib/big_decimal.rb
    > be rubocop -a lib/big_decimal.rb

<!SLIDE>
# Internal Affairs - Control the cops

* Configuration (.rubocop.yml)
* Disable Oneline
* Disable/Enable Block

<!SLIDE>
# Internal Affairs In Action

    @@@ Console
    > cat lib/disable.rb
    # rubocop:disable UselessAssignment
    for x in (0..19) # rubocop:disable Style/For
    end
    # rubocop:enable UselessAssignment
    >
    > be rubocop lib/disable.rb


<!SLIDE>
# Improving Your Code - Style

* Mostly from [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
* Countless layout / style options. Choose and stick.
* Example [NumericPredicate](http://rubocop.readthedocs.io/en/latest/cops_style/#stylenumericpredicate)

<!SLIDE>
# Improving Your Code - Rails

    @@@Ruby
    def bad_use_of_time
      Rails.logger.debug Time.now
    end

    def foobar
      foo.present? ? foo : 'bar'
    end

<!SLIDE>
# Improving Your Code - Metrics

* [AbcMetric](http://c2.com/cgi/wiki?AbcMetric)
  * A == Assignments
  * B == Branches
  * C == Conditions
* [CyclomaticComplexity](http://c2.com/cgi/wiki?CyclomaticComplexityMetric)
  * Count of conditions (if/unless/while/ternary)
* [PerceivedComplexity](http://c2.com/cgi/wiki?CyclomaticComplexityMetric)
  * Similar to Cyclomatic but includes `else` and minimizes `when`

<!SLIDE>
# Metrics Example - lib/reddit.rb

Let's fix together

<!SLIDE>
# Rob's Opinions

* Have it in your code editor
* Choose and Stick With Your Config
* Don't require for a clean build