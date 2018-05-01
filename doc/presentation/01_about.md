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
# Digging in To Code - Boolean Symbol

https://github.com/bbatsov/rubocop/blob/master/lib/rubocop/cop/lint/boolean_symbol.rb

    @@@ Bash
    be ruby-parse  lib/boolean_symbol.rb
    rubocop lib/boolean_symbol.rb

* https://github.com/bbatsov/rubocop/blob/master/lib/rubocop/cop/lint/big_decimal_new.rb


