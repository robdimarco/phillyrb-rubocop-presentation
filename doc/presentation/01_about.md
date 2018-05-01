<!SLIDE >
# Rubocop is...

* Static Code Analysis
* Best Practice Enforcer
* Teacher of Ruby

<!SLIDE>
# Installation / Running

    @@@ Bash
    gem install rubocop # bundle install
    be rubocop

<!SLIDE>
# How It Works

* `parser` to create an Abstract Syntaxt Tree from Ruby files
* "Cops" define matching rules, violation documentation, and (sometimes) auto-correct
* Cops are organized in to departments

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

    @@@ Bash
    cat lib/boolean_sumbol.rb
    be ruby-parse  lib/boolean_symbol.rb
    be rubocop lib/boolean_symbol.rb

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

    @@@ Bash
    cat lib/big_decimal.rb
    be ruby-parse  lib/big_decimal.rb
    be rubocop lib/big_decimal.rb
    be rubocop -a lib/big_decimal.rb

<!SLIDE>
# Internal Affairs - Control the cops

* Configuration (.rubocop.yml)
* Disable Oneline
* Disable/Enable Block

<!SLIDE>
# Cop In Action

    @@@ Bash
    cat lib/disable.rb
    be rubocop lib/disable.rb


<!SLIDE>
# Improving Your Code - Style

* Most based on [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
*

<!SLIDE>
# Improving Your Code - Metrics


<!SLIDE>
# Improving Your Code - A Better Way



* [Metrics]
* [Performance]
