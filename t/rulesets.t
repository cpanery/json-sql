use 5.014;

use strict;
use warnings;

use JSON::Validator;
use Test::More;
use YAML::PP;

my $yaml = YAML::PP->new(boolean => 'JSON::PP');

my ($schema) = $yaml->load_file('./rulesets.yaml');

ok $schema->{'$id'}, 'has $id';
ok $schema->{'$schema'}, 'has $schema';

is_deeply $schema->{'oneOf'},
  [{'$ref' => '#/definitions/query'}, {'$ref' => '#/definitions/transaction'}],
  'has root; accepts (query or transaction)';

for my $name (sort keys %{$schema->{definitions}}) {
  subtest "definition ($name) is valid", sub {
    my $def = $schema->{definitions}{$name};

    if ($ENV{TEST_DEBUG}) {
      diag $def->{description};
    }

    if ($def->{type}) {
      if ($name eq 'type') {
        is $def->{type}, 'string', "$name root type is (string)";
      }
      elsif ($name eq 'literal') {
        is_deeply $def->{type},
          ['string', 'number', 'integer', 'boolean', 'null'],
          "$name root type is ('string', 'number', 'integer', 'boolean', 'null')";
      }
      else {
        is $def->{type}, 'object', "$name root type is (object)";
      }
    }
    else {
      ok $def->{'oneOf'} || $def->{'allOf'} || $def->{'anyOf'},
        "$name root type is ('allOf', 'anyOf', 'oneOf')";
    }
    unless ($name eq 'query'
      || $name eq 'expression'
      || $name eq 'criteria'
      || $name eq 'literal'
      || $name eq 'type')
    {
      ok $def->{required}, "$name has at-least one required property";
    }

    my $validator = JSON::Validator->new;

    $validator->schema({%$def, definitions => $schema->{definitions}});
    $validator->coerce('booleans');

    for my $item (sort keys %{$def->{'x-examples'}}) {
      my $example = $def->{'x-examples'}{$item};
      my @errors = $validator->validate($example);

      if ($ENV{TEST_DEBUG}) {
        diag join "\n", map "$_", sort @errors if @errors;
        diag explain $example if @errors;
      }

      ok !@errors, "$name ($item) is a valid example";
    }
  };
}

ok 1 and done_testing;
