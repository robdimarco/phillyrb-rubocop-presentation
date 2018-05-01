<!SLIDE  center>
# Rubocop is...

* Static Code Analysis
* Best Practice Enforcer
* Teacher

<!SLIDE center>
# Installation / Running

    @@@ Bash
    gem install rubocop
    rubocop

<!SLIDE center>
# The Cops
* Cop
*

<!SLIDE center>
# How It Works

* `parser` gem to create Abstract Syntax Tree
* Cops define matching syntax
* Cops can supply warnings and corrections

<!SLIDE center>
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

<!SLIDE center>
# Cop In Action

    @@@ Bash
    cat lib/boolean_sumbol.rb
    be ruby-parse  lib/boolean_symbol.rb
    rubocop lib/boolean_symbol.rb

<!SLIDE center>
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

<!SLIDE center>
# Cop In Action

    @@@ Bash
    cat lib/big_decimal.rb
    be ruby-parse  lib/big_decimal.rb
    rubocop lib/big_decimal.rb
    rubocop -a lib/big_decimal.rb

