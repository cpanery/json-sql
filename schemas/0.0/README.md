# JSON-SQL

JSON-SQL is a specification which defines a standard for describing SQL
statements using language-agnostic representations (data structures). This
specification aims to be standards-compliant, i.e. supporting the full-range of
SQL-92 expressions, and to enable the development of better (more accurate and
robust) SQL statement generation, libraries, object-mappers, and other tooling.
The specification is a valid JSON-Schema document which can be validated using
any JSON-Schema validator with support for
_"https://json-schema.org/draft/2019-09/schema"_.

## Features

- vendor-agnostic
- language-agnostic
- sql as a data exchange format
- pre-flight sql statement syntax validation
- common sql coverage (99.999% standards-compliant)

**note:** sql parser and generator not included

## Demonstration

This example JSON-SQL data structure:

```
{
   "table-create" : {
      "name" : "inactive_users",
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "*"
               }
            ],
            "from" : {
               "table" : "users"
            },
            "where" : [
              {
                "eq": [
                  {
                    "column" : "verified"
                  },
                  1
                ]
              },
              {
                "not-null": {
                  "column" : "deleted"
                }
              }
            ]
         }
      },
      "safe" : true,
      "temp" : true
   }
}
```

Could be used to generate this SQL query:

```
CREATE TEMPORARY TABLE IF NOT EXISTS inactive_users AS (
  SELECT * FROM users WHERE verified = 1 AND deleted IS NOT NULL
)
```

## Definitions

- [as](#as)
- [binary](#binary)
- [binding](#binding)
- [case](#case)
- [cast](#cast)
- [column](#column)
- [column-change](#column-change)
- [column-create](#column-create)
- [column-definition](#column-definition)
- [column-drop](#column-drop)
- [column-rename](#column-rename)
- [constraint-condition](#constraint-condition)
- [constraint-create](#constraint-create)
- [constraint-drop](#constraint-drop)
- [criteria](#criteria)
- [criterion-and](#criterion-and)
- [criterion-between](#criterion-between)
- [criterion-eq](#criterion-eq)
- [criterion-glob](#criterion-glob)
- [criterion-gt](#criterion-gt)
- [criterion-gte](#criterion-gte)
- [criterion-in](#criterion-in)
- [criterion-is](#criterion-is)
- [criterion-is-null](#criterion-is-null)
- [criterion-like](#criterion-like)
- [criterion-lt](#criterion-lt)
- [criterion-lte](#criterion-lte)
- [criterion-ne](#criterion-ne)
- [criterion-not](#criterion-not)
- [criterion-not-null](#criterion-not-null)
- [criterion-or](#criterion-or)
- [criterion-regexp](#criterion-regexp)
- [database-create](#database-create)
- [database-drop](#database-drop)
- [delete](#delete)
- [expression](#expression)
- [function](#function)
- [index-create](#index-create)
- [index-drop](#index-drop)
- [insert](#insert)
- [literal](#literal)
- [query](#query)
- [schema-create](#schema-create)
- [schema-drop](#schema-drop)
- [schema-rename](#schema-rename)
- [select](#select)
- [subquery](#subquery)
- [table](#table)
- [table-create](#table-create)
- [table-drop](#table-drop)
- [table-rename](#table-rename)
- [transaction](#transaction)
- [type](#type)
- [unary](#unary)
- [update](#update)
- [verbatim](#verbatim)
- [view-create](#view-create)
- [view-drop](#view-drop)

## as

AS is an EXPRESSION which declares an alias for another EXPRESSION, typically in a column SELECT definition.

[definitions](#definitions)

### example-1

```
{
   "as" : [
      "active",
      1
   ]
}
```

### example-2

```
{
   "as" : [
      "inactive",
      0
   ]
}
```

### example-3

```
{
   "as" : [
      "ssn",
      {
         "column" : "social_security_number"
      }
   ]
}
```

## binary

BINARY is an EXPRESSION which uses the first and second EXPRESSION to perform a binary operation.

[definitions](#definitions)

### example-1

```
{
   "binary" : {
      "plus" : [
         123,
         1
      ]
   }
}
```

### example-2

```
{
   "binary" : {
      "minus" : [
         123,
         1
      ]
   }
}
```

### example-3

```
{
   "binary" : {
      "plus" : [
         {
            "column" : "count"
         },
         1
      ]
   }
}
```

### example-4

```
{
   "binary" : {
      "minus" : [
         {
            "column" : "count"
         },
         1
      ]
   }
}
```

### example-5

```
{
   "binary" : {
      "multiply" : [
         25,
         25
      ]
   }
}
```

### example-6

```
{
   "binary" : {
      "divide" : [
         100,
         5
      ]
   }
}
```

### example-7

```
{
   "binary" : {
      "modulo" : [
         29,
         9
      ]
   }
}
```

## binding

BINDING is an EXPRESSION which represents is a named-placeholder to be substituted later.

[definitions](#definitions)

### example-1

```
{
   "binding" : "token"
}
```

### example-2

```
{
   "binding" : "uuid"
}
```

## case

CASE is an EXPRESSION which provides a mechanism for declaring conditional expressions.

[definitions](#definitions)

### example-1

```
{
   "case" : {
      "else" : "user",
      "when" : [
         {
            "cond" : {
               "eq" : [
                  "admin",
                  "admin"
               ]
            },
            "then" : "admin"
         }
      ]
   }
}
```

### example-2

```
{
   "case" : {
      "else" : 0,
      "when" : [
         {
            "cond" : {
               "eq" : [
                  {
                     "column" : "role"
                  },
                  "admin"
               ]
            },
            "then" : 1
         }
      ]
   }
}
```

### example-3

```
{
   "case" : {
      "else" : 0,
      "when" : [
         {
            "cond" : {
               "eq" : [
                  {
                     "column" : "role"
                  },
                  "admin"
               ]
            },
            "then" : 1
         },
         {
            "cond" : {
               "eq" : [
                  {
                     "column" : "role"
                  },
                  "manager"
               ]
            },
            "then" : 2
         }
      ]
   }
}
```

## cast

CAST is an EXPRESSION which specifies a conversion from one data type to another.

[definitions](#definitions)

### example-1

```
{
   "cast" : [
      12.34,
      "int"
   ]
}
```

### example-2

```
{
   "cast" : [
      "2020-01-01",
      "datetime"
   ]
}
```

### example-3

```
{
   "cast" : [
      {
         "function" : [
            "date",
            "now"
         ]
      },
      "varchar"
   ]
}
```

## column

COLUMN represents TABLE column reference.

[definitions](#definitions)

### example-1

```
{
   "column" : "id"
}
```

### example-2

```
{
   "column" : "created"
}
```

## column-change

COLUMN-CHANGE changes the definition of an existing table and column.

[definitions](#definitions)

### example-1

```
{
   "column-change" : {
      "column" : {
         "name" : "login_attempts",
         "nullable" : false,
         "type" : "integer-big"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "column-change" : {
      "column" : {
         "default" : {
            "verbatim" : [
               "CURRENT_TIMESTAMP"
            ]
         },
         "name" : "last_login_at",
         "type" : "timestamp"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

## column-create

COLUMN-CREATE changes the definition of an existing table by adding a new column.

[definitions](#definitions)

### example-1

```
{
   "column-create" : {
      "column" : {
         "name" : "email",
         "type" : "string"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "column-create" : {
      "column" : {
         "name" : "verified",
         "nullable" : true,
         "type" : "date"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

### example-3

```
{
   "column-create" : {
      "column" : {
         "increment" : true,
         "name" : "id",
         "nullable" : false,
         "primary" : true,
         "type" : "integer"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

## column-definition

COLUMN-DEFINITION represents a table column definition.

[definitions](#definitions)

### example-1

```
{
   "name" : "id",
   "type" : "number"
}
```

### example-2

```
{
   "increment" : true,
   "name" : "id",
   "primary" : true,
   "type" : "integer"
}
```

### example-3

```
{
   "name" : "fullname",
   "nullable" : false,
   "type" : "string"
}
```

### example-4

```
{
   "default" : "guest",
   "name" : "role",
   "type" : "string"
}
```

### example-5

```
{
   "default" : "dark",
   "name" : "theme",
   "options" : [
      "light",
      "dark"
   ],
   "type" : "enum"
}
```

## column-drop

COLUMN-DROP removes an existing column from an existing table.

[definitions](#definitions)

### example-1

```
{
   "column-drop" : {
      "column" : "phone",
      "table" : "users"
   }
}
```

## column-rename

COLUMN-RENAME changes the definition of an existing table by renaming a new column.

[definitions](#definitions)

### example-1

```
{
   "column-rename" : {
      "for" : {
         "table" : "users"
      },
      "name" : {
         "new" : "email_address",
         "old" : "email"
      }
   }
}
```

### example-2

```
{
   "column-rename" : {
      "for" : {
         "table" : "users"
      },
      "name" : {
         "new" : "created_at",
         "old" : "created"
      }
   }
}
```

### example-3

```
{
   "column-rename" : {
      "for" : {
         "table" : "users"
      },
      "name" : {
         "new" : "updated_at",
         "old" : "updated"
      }
   }
}
```

### example-4

```
{
   "column-rename" : {
      "for" : {
         "table" : "users"
      },
      "name" : {
         "new" : "updated_at",
         "old" : "updated"
      },
      "safe" : true
   }
}
```

## constraint-condition

CONSTRAINT-CONDITION represents a table constraint on-update/on-delete condition.

[definitions](#definitions)

### example-1

```
{
   "delete" : "cascade",
   "update" : "cascade"
}
```

### example-2

```
{
   "delete" : "cascade",
   "update" : "no-action"
}
```

### example-3

```
{
   "delete" : "set-null",
   "update" : "set-null"
}
```

## constraint-create

CONSTRAINT-CREATE changes the definition of an existing table by adding a new foreign-key constraint.

[definitions](#definitions)

### example-1

```
{
   "constraint-create" : {
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

### example-2

```
{
   "constraint-create" : {
      "name" : "fkey_users_profile_id",
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

### example-3

```
{
   "constraint-create" : {
      "name" : "fkey_users_profile_id",
      "on" : {
         "delete" : "cascade",
         "update" : "cascade"
      },
      "safe" : true,
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

## constraint-drop

CONSTRAINT-DROP removes an existing foreign-key constraint.

[definitions](#definitions)

### example-1

```
{
   "constraint-drop" : {
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

### example-2

```
{
   "constraint-drop" : {
      "name" : "fkey_users_profile_id",
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

### example-3

```
{
   "constraint-drop" : {
      "name" : "fkey_users_profile_id",
      "safe" : true,
      "source" : {
         "table" : "users"
      }
   }
}
```

## criteria

CRITERIA is a set of rules (criterion) which can be combined to create conditions and clauses which filter SQL datasets.

[definitions](#definitions)

### example-1

```
{
   "in" : [
      {
         "column" : "theme"
      },
      "light",
      "dark"
   ]
}
```

### example-2

```
{
   "is-null" : {
      "column" : "deleted"
   }
}
```

### example-3

```
{
   "not-null" : {
      "column" : "deleted"
   }
}
```

### example-4

```
{
   "eq" : [
      {
         "column" : "role"
      },
      "admin"
   ]
}
```

### example-5

```
{
   "glob" : [
      {
         "column" : "filename"
      },
      "*.txt"
   ]
}
```

### example-6

```
{
   "gt" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

### example-7

```
{
   "gte" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

### example-8

```
{
   "like" : [
      {
         "column" : "email"
      },
      "%@example.com"
   ]
}
```

### example-9

```
{
   "lte" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

### example-10

```
{
   "lt" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

### example-11

```
{
   "ne" : [
      {
         "column" : "status"
      },
      "unknown"
   ]
}
```

### example-12

```
{
   "regexp" : [
      {
         "column" : "username"
      },
      "^admin$"
   ]
}
```

### example-13

```
{
   "and" : [
      {
         "eq" : [
            {
               "column" : "role"
            },
            "guest"
         ]
      },
      {
         "not-null" : {
            "column" : "verified"
         }
      }
   ]
}
```

### example-14

```
{
   "or" : [
      {
         "eq" : [
            {
               "column" : "role"
            },
            "guest"
         ]
      },
      {
         "eq" : [
            {
               "column" : "role"
            },
            "user"
         ]
      }
   ]
}
```

### example-15

```
{
   "is" : {
      "column" : "verified"
   }
}
```

### example-16

```
{
   "is" : [
      {
         "eq" : [
            {
               "column" : "verified"
            },
            {
               "column" : "processed"
            }
         ]
      }
   ]
}
```

## criterion-and

CRITERION-AND is a criterion which represents a condition which joins the CRITERIA provided using the "AND" operator.

[definitions](#definitions)

### example-1

```
{
   "and" : [
      {
         "eq" : [
            {
               "column" : "role"
            },
            "guest"
         ]
      },
      {
         "not-null" : {
            "column" : "verified"
         }
      }
   ]
}
```

## criterion-between

CRITERION-BETWEEN is a criterion which requires the first EXPRESSION to exist within the range that exists between the second and third EXPRESSION.

[definitions](#definitions)

### example-1

```
{
   "between" : [
      {
         "column" : "created"
      },
      {
         "column" : "updated"
      }
   ]
}
```

### example-2

```
{
   "between" : [
      {
         "column" : "created"
      },
      {
         "function" : [
            "date",
            "now"
         ]
      }
   ]
}
```

### example-3

```
{
   "between" : [
      {
         "column" : "created"
      },
      {
         "function" : [
            "date",
            "now"
         ]
      }
   ]
}
```

### example-4

```
{
   "between" : [
      {
         "function" : [
            "datetime",
            1092941466,
            "unixepoch"
         ]
      },
      {
         "function" : [
            "date",
            "now"
         ]
      }
   ]
}
```

## criterion-eq

CRITERION-EQ is a criterion which represents an "equal" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "eq" : [
      {
         "column" : "role"
      },
      "admin"
   ]
}
```

## criterion-glob

CRITERION-GLOB is a criterion which represents a "glob" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "glob" : [
      {
         "column" : "filename"
      },
      "*.txt"
   ]
}
```

## criterion-gt

CRITERION-GT is a criterion which represents a "greater than" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "gt" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

## criterion-gte

CRITERION-GTE is a criterion which represents a "greater than or equal to" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "gte" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

## criterion-in

CRITERION-IN is a criterion which represents an "is included in the set" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "in" : [
      {
         "column" : "theme"
      },
      "light",
      "dark"
   ]
}
```

## criterion-is

CRITERION-IS is a criterion which represents a scoped expression or criteria.

[definitions](#definitions)

### example-1

```
{
   "is" : {
      "column" : "verified"
   }
}
```

### example-2

```
{
   "is" : [
      {
         "eq" : [
            {
               "column" : "verified"
            },
            {
               "column" : "processed"
            }
         ]
      }
   ]
}
```

## criterion-is-null

CRITERION-IS-NULL is a criterion which represents an "is null" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "is-null" : {
      "column" : "deleted"
   }
}
```

## criterion-like

CRITERION-LIKE is a criterion which represents a "like" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "like" : [
      {
         "column" : "email"
      },
      "%@example.com"
   ]
}
```

## criterion-lt

CRITERION-LT is a criterion which represents a "less than" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "lt" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

## criterion-lte

CRITERION-LTE is a criterion which represents a "less than or equal to" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "lte" : [
      {
         "column" : "total"
      },
      1.23
   ]
}
```

## criterion-ne

CRITERION-NE is a criterion which represents a "not equal" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "ne" : [
      {
         "column" : "status"
      },
      "unknown"
   ]
}
```

## criterion-not

CRITERION-NOT is a criterion which represents a scoped negation of an expression or criteria.

[definitions](#definitions)

### example-1

```
{
   "not" : {
      "column" : "verified"
   }
}
```

### example-2

```
{
   "not" : [
      {
         "eq" : [
            {
               "column" : "verified"
            },
            {
               "column" : "processed"
            }
         ]
      }
   ]
}
```

## criterion-not-null

CRITERION-NOT-NULL is a criterion which represents an "is not null" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "not-null" : {
      "column" : "deleted"
   }
}
```

## criterion-or

CRITERION-OR is a condition which joins the CRITERIA provided using the "OR" operator.

[definitions](#definitions)

### example-1

```
{
   "or" : [
      {
         "eq" : [
            {
               "column" : "role"
            },
            "guest"
         ]
      },
      {
         "eq" : [
            {
               "column" : "role"
            },
            "user"
         ]
      }
   ]
}
```

## criterion-regexp

CRITERION-REGEXP is a criterion which represents a "regexp" comparison operation.

[definitions](#definitions)

### example-1

```
{
   "regexp" : [
      {
         "column" : "username"
      },
      "^admin$"
   ]
}
```

## database-create

DATABASE-CREATE creates a new database.

[definitions](#definitions)

### example-1

```
{
   "database-create" : {
      "name" : "users"
   }
}
```

### example-2

```
{
   "database-create" : {
      "name" : "users",
      "safe" : true
   }
}
```

## database-drop

DATABASE-DROP removes an existing database.

[definitions](#definitions)

### example-1

```
{
   "database-drop" : {
      "name" : "users"
   }
}
```

### example-2

```
{
   "database-drop" : {
      "name" : "users",
      "safe" : true
   }
}
```

## delete

DELETE deletes existing rows from the table.

[definitions](#definitions)

### example-1

```
{
   "delete" : {
      "from" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "delete" : {
      "from" : {
         "table" : "users"
      },
      "where" : [
         {
            "eq" : [
               {
                  "column" : "id"
               },
               123
            ]
         }
      ]
   }
}
```

### example-3

```
{
   "delete" : {
      "from" : {
         "table" : "users"
      },
      "returning" : [
         {
            "column" : "*"
         }
      ]
   }
}
```

## expression

EXPRESSION represents a valid SQL expression.

[definitions](#definitions)

### example-1

```
123
```

### example-2

```
{
   "column" : "id"
}
```

### example-3

```
{
   "function" : [
      "now"
   ]
}
```

### example-4

```
{
   "binding" : "login"
}
```

### example-5

```
{
   "binary" : {
      "plus" : [
         1,
         1
      ]
   }
}
```

### example-6

```
{
   "unary" : {
      "plus" : 1
   }
}
```

### example-7

```
{
   "cast" : [
      12.34,
      "int"
   ]
}
```

### example-8

```
{
   "case" : {
      "else" : 0,
      "when" : [
         {
            "cond" : {
               "eq" : [
                  1,
                  1
               ]
            },
            "then" : 1
         }
      ]
   }
}
```

### example-9

```
{
   "verbatim" : [
      true
   ]
}
```

### example-10

```
{
   "verbatim" : [
      false
   ]
}
```

### example-11

```
{
   "as" : [
      "subtotal",
      {
         "column" : "subtotal"
      }
   ]
}
```

## function

FUNCTION is an EXPRESSION which represents a built-in SQL function.

[definitions](#definitions)

### example-1

```
{
   "function" : [
      true
   ]
}
```

### example-2

```
{
   "function" : [
      false
   ]
}
```

### example-3

```
{
   "function" : [
      "date",
      "now"
   ]
}
```

## index-create

INDEX-CREATE changes the definition of an existing table by adding a new column index.

[definitions](#definitions)

### example-1

```
{
   "index-create" : {
      "columns" : [
         {
            "column" : "email"
         }
      ],
      "for" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "index-create" : {
      "columns" : [
         {
            "column" : "email"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "name" : "idx_users_email"
   }
}
```

### example-3

```
{
   "index-create" : {
      "columns" : [
         {
            "column" : "email"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "name" : "idx_uni_users_email",
      "unique" : true
   }
}
```

## index-drop

INDEX-DROP removes an existing new column index.

[definitions](#definitions)

### example-1

```
{
   "index-drop" : {
      "columns" : [
         {
            "column" : "email"
         }
      ],
      "for" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "index-drop" : {
      "columns" : [
         {
            "column" : "email"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "name" : "indx_users_email"
   }
}
```

### example-3

```
{
   "index-drop" : {
      "columns" : [
         {
            "column" : "email"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "name" : "indx_users_email",
      "unique" : true
   }
}
```

### example-4

```
{
   "index-drop" : {
      "name" : "indx_users_email"
   }
}
```

## insert

INSERT inserts new rows into a table.

[definitions](#definitions)

### example-1

```
{
   "insert" : {
      "into" : {
         "table" : "users"
      },
      "values" : [
         {
            "value" : 1
         },
         {
            "value" : "root"
         },
         {
            "value" : "secret"
         }
      ]
   }
}
```

### example-2

```
{
   "insert" : {
      "columns" : [
         {
            "column" : "id"
         },
         {
            "column" : "login"
         },
         {
            "column" : "password"
         }
      ],
      "into" : {
         "table" : "users"
      },
      "values" : [
         {
            "value" : 1
         },
         {
            "value" : "root"
         },
         {
            "value" : "secret"
         }
      ]
   }
}
```

### example-3

```
{
   "insert" : {
      "default" : true,
      "into" : {
         "table" : "users"
      }
   }
}
```

### example-4

```
{
   "insert" : {
      "into" : {
         "table" : "users"
      },
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "*"
               }
            ],
            "from" : {
               "table" : "users"
            }
         }
      }
   }
}
```

### example-5

```
{
   "insert" : {
      "columns" : [
         {
            "column" : "login"
         },
         {
            "column" : "password"
         }
      ],
      "into" : {
         "table" : "users"
      },
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "username"
               },
               {
                  "column" : "password"
               }
            ],
            "from" : {
               "table" : "applicants"
            },
            "where" : [
               {
                  "not-null" : {
                     "column" : "verified"
                  }
               }
            ]
         }
      }
   }
}
```

### example-6

```
{
   "insert" : {
      "into" : {
         "table" : "users"
      },
      "returning" : [
         {
            "column" : "*"
         }
      ],
      "values" : [
         {
            "value" : 1
         },
         {
            "value" : "root"
         },
         {
            "value" : "secret"
         }
      ]
   }
}
```

## literal

LITERAL represents acceptable raw SQL data types.

[definitions](#definitions)

### example-1

```
"secret"
```

### example-2

```
12345
```

### example-3

```
1.2345
```

### example-4

```
-12345
```

### example-5

```
false
```

### example-6

```
true
```

### example-7

```
null
```

## query

QUERY represents a valid SQL statement.

[definitions](#definitions)

### example-1

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "insert" : {
      "into" : {
         "table" : "users"
      },
      "values" : [
         {
            "value" : 1
         },
         {
            "value" : "root"
         },
         {
            "value" : "secret"
         }
      ]
   }
}
```

### example-3

```
{
   "update" : {
      "columns" : [
         {
            "column" : "login",
            "value" : "admin"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "where" : [
         {
            "not-null" : {
               "column" : "verified"
            }
         }
      ]
   }
}
```

### example-4

```
{
   "delete" : {
      "from" : {
         "table" : "users"
      }
   }
}
```

### example-5

```
{
   "column-create" : {
      "column" : {
         "name" : "email",
         "type" : "string"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

### example-6

```
{
   "column-rename" : {
      "for" : {
         "table" : "users"
      },
      "name" : {
         "new" : "email_address",
         "old" : "email"
      }
   }
}
```

### example-7

```
{
   "constraint-create" : {
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

### example-8

```
{
   "constraint-drop" : {
      "source" : {
         "column" : "profile_id",
         "table" : "users"
      },
      "target" : {
         "column" : "id",
         "table" : "profiles"
      }
   }
}
```

### example-9

```
{
   "database-create" : {
      "name" : "users"
   }
}
```

### example-10

```
{
   "database-drop" : {
      "name" : "users"
   }
}
```

### example-11

```
{
   "schema-create" : {
      "name" : "private"
   }
}
```

### example-12

```
{
   "schema-drop" : {
      "name" : "private"
   }
}
```

### example-13

```
{
   "schema-rename" : {
      "name" : {
         "new" : "internal",
         "old" : "private"
      }
   }
}
```

### example-14

```
{
   "table-create" : {
      "columns" : [
         {
            "increment" : true,
            "name" : "id",
            "primary" : true,
            "type" : "integer"
         }
      ],
      "name" : "users"
   }
}
```

### example-15

```
{
   "table-drop" : {
      "name" : "users"
   }
}
```

### example-16

```
{
   "table-rename" : {
      "name" : {
         "new" : "staff",
         "old" : "users"
      }
   }
}
```

### example-17

```
{
   "view-create" : {
      "name" : "active_users",
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "*"
               }
            ],
            "from" : {
               "table" : "users"
            },
            "where" : [
               {
                  "not-null" : {
                     "column" : "active"
                  }
               }
            ]
         }
      }
   }
}
```

### example-18

```
{
   "view-drop" : {
      "name" : "active_users"
   }
}
```

## schema-create

SCHEMA-CREATE enters a new schema into the current database.

[definitions](#definitions)

### example-1

```
{
   "schema-create" : {
      "name" : "private"
   }
}
```

### example-2

```
{
   "schema-create" : {
      "name" : "private",
      "safe" : true
   }
}
```

## schema-drop

SCHEMA-DROP removes an existing schema from the current database.

[definitions](#definitions)

### example-1

```
{
   "schema-drop" : {
      "name" : "private"
   }
}
```

### example-2

```
{
   "schema-drop" : {
      "name" : "private",
      "safe" : true
   }
}
```

## schema-rename

SCHEMA-RENAME renames an existing schema definition.

[definitions](#definitions)

### example-1

```
{
   "schema-rename" : {
      "name" : {
         "new" : "internal",
         "old" : "private"
      }
   }
}
```

## select

SELECT retrieves rows from zero or more tables.

[definitions](#definitions)

### example-1

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      }
   }
}
```

### example-2

```
{
   "select" : {
      "columns" : [
         {
            "column" : "id"
         },
         {
            "column" : "login"
         }
      ],
      "from" : {
         "table" : "users"
      }
   }
}
```

### example-3

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "where" : [
         {
            "not-null" : {
               "column" : "verified"
            }
         }
      ]
   }
}
```

### example-4

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "alias" : "u",
         "table" : "users"
      },
      "joins" : [
         {
            "having" : [
               {
                  "eq" : [
                     {
                        "alias" : "p",
                        "column" : "id"
                     },
                     {
                        "alias" : "u",
                        "column" : "profile_id"
                     }
                  ]
               }
            ],
            "with" : {
               "alias" : "p",
               "table" : "profiles"
            }
         }
      ]
   }
}
```

### example-5

```
{
   "select" : {
      "columns" : [
         {
            "function" : [
               "count",
               {
                  "column" : "id"
               }
            ]
         },
         {
            "column" : "country"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "group-by" : [
         {
            "column" : "country"
         }
      ]
   }
}
```

### example-6

```
{
   "select" : {
      "columns" : [
         {
            "function" : [
               "count",
               {
                  "column" : "id"
               }
            ]
         },
         {
            "column" : "country"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "group-by" : [
         {
            "column" : "country"
         }
      ],
      "having" : [
         {
            "gt" : [
               {
                  "function" : [
                     "count",
                     {
                        "column" : "id"
                     }
                  ]
               },
               5
            ]
         }
      ]
   }
}
```

### example-7

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "order-by" : [
         {
            "column" : "id",
            "sort" : "desc"
         }
      ]
   }
}
```

### example-8

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "order-by" : [
         {
            "column" : "id",
            "sort" : "desc"
         },
         {
            "column" : "login",
            "sort" : "asc"
         }
      ]
   }
}
```

### example-9

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "rows" : {
         "limit" : 10
      }
   }
}
```

### example-10

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "table" : "users"
      },
      "rows" : {
         "limit" : 10,
         "offset" : 10
      }
   }
}
```

### example-11

```
{
   "select" : {
      "columns" : [
         {
            "alias" : "s",
            "column" : "*"
         },
         {
            "alias" : "u",
            "column" : "*"
         }
      ],
      "from" : [
         {
            "alias" : "s",
            "table" : "staff"
         },
         {
            "alias" : "u",
            "table" : "users"
         }
      ],
      "where" : [
         {
            "eq" : [
               {
                  "alias" : "s",
                  "column" : "user_id"
               },
               {
                  "alias" : "u",
                  "column" : "id"
               }
            ]
         }
      ]
   }
}
```

### example-12

```
{
   "select" : {
      "columns" : [
         {
            "column" : "*"
         }
      ],
      "from" : {
         "alias" : "u",
         "table" : "users"
      },
      "joins" : [
         {
            "having" : [
               {
                  "eq" : [
                     {
                        "alias" : "p",
                        "column" : "id"
                     },
                     {
                        "alias" : "u",
                        "column" : "profile_id"
                     }
                  ]
               }
            ],
            "type" : "inner-join",
            "with" : {
               "alias" : "p",
               "table" : "profiles"
            }
         }
      ]
   }
}
```

## subquery

SUBQUERY represents a SELECT (SQL select statement) as an EXPRESSION.

[definitions](#definitions)

### example-1

```
{
   "subquery" : {
      "select" : {
         "columns" : [
            {
               "column" : "id"
            }
         ],
         "from" : {
            "table" : "users"
         }
      }
   }
}
```

### example-2

```
{
   "subquery" : {
      "select" : {
         "columns" : [
            {
               "function" : [
                  "count",
                  {
                     "column" : "id"
                  }
               ]
            }
         ],
         "from" : {
            "table" : "users"
         }
      }
   }
}
```

## table

TABLE represents a DATABASE table reference.

[definitions](#definitions)

### example-1

```
{
   "table" : "users"
}
```

### example-2

```
{
   "alias" : "u",
   "table" : "users"
}
```

## table-create

TABLE-CREATE will create a new, initially empty table in the current database.

[definitions](#definitions)

### example-1

```
{
   "table-create" : {
      "columns" : [
         {
            "increment" : true,
            "name" : "id",
            "primary" : true,
            "type" : "integer"
         }
      ],
      "name" : "users"
   }
}
```

### example-2

```
{
   "table-create" : {
      "columns" : [
         {
            "increment" : true,
            "name" : "id",
            "primary" : true,
            "type" : "integer"
         }
      ],
      "name" : "removed_users",
      "safe" : true,
      "temp" : true
   }
}
```

### example-3

```
{
   "table-create" : {
      "name" : "removed_users",
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "id"
               },
               {
                  "column" : "login"
               }
            ],
            "from" : {
               "table" : "users"
            }
         }
      },
      "safe" : true,
      "temp" : true
   }
}
```

### example-4

```
{
   "table-create" : {
      "columns" : [
         {
            "increment" : true,
            "name" : "id",
            "primary" : true,
            "type" : "integer"
         },
         {
            "name" : "email",
            "type" : "string"
         }
      ],
      "constraints" : [
         {
            "unique" : {
               "columns" : [
                  "email"
               ]
            }
         }
      ],
      "name" : "users"
   }
}
```

### example-5

```
{
   "table-create" : {
      "columns" : [
         {
            "increment" : true,
            "name" : "id",
            "primary" : true,
            "type" : "integer"
         },
         {
            "name" : "profile_id",
            "type" : "integer"
         }
      ],
      "constraints" : [
         {
            "foreign" : {
               "column" : "profile_id",
               "reference" : {
                  "column" : "id",
                  "table" : "profiles"
               }
            }
         }
      ],
      "name" : "users"
   }
}
```

## table-drop

TABLE-DROP removes tables from the database.

[definitions](#definitions)

### example-1

```
{
   "table-drop" : {
      "name" : "users"
   }
}
```

### example-2

```
{
   "table-drop" : {
      "name" : "users",
      "safe" : true
   }
}
```

### example-3

```
{
   "table-drop" : {
      "condition" : "cascade",
      "name" : "users",
      "safe" : true
   }
}
```

## table-rename

TABLE-RENAME changes the definition of an existing table.

[definitions](#definitions)

### example-1

```
{
   "table-rename" : {
      "name" : {
         "new" : "staff",
         "old" : "users"
      }
   }
}
```

### example-2

```
{
   "table-rename" : {
      "name" : {
         "new" : "staff",
         "old" : "users"
      },
      "safe" : true
   }
}
```

## transaction

TRANSACTION represents a set of valid SQL statements to be executed within a database transaction.

[definitions](#definitions)

### example-1

```
{
   "transaction" : {
      "queries" : [
         {
            "table-create" : {
               "columns" : [
                  {
                     "name" : "id",
                     "primary" : true,
                     "type" : "integer"
                  }
               ],
               "name" : "users"
            }
         },
         {
            "table-create" : {
               "columns" : [
                  {
                     "name" : "id",
                     "primary" : true,
                     "type" : "integer"
                  }
               ],
               "name" : "profiles"
            }
         }
      ]
   }
}
```

### example-2

```
{
   "transaction" : {
      "mode" : [
         "deferrable"
      ],
      "queries" : [
         {
            "table-create" : {
               "columns" : [
                  {
                     "name" : "id",
                     "primary" : true,
                     "type" : "integer"
                  }
               ],
               "name" : "users"
            }
         },
         {
            "table-create" : {
               "columns" : [
                  {
                     "name" : "id",
                     "primary" : true,
                     "type" : "integer"
                  }
               ],
               "name" : "profiles"
            }
         }
      ]
   }
}
```

## type

TYPE represents an acceptable SQL data type string.

[definitions](#definitions)

### example-1

```
"binary"
```

### example-2

```
"boolean"
```

### example-3

```
"char"
```

### example-4

```
"date"
```

### example-5

```
"datetime"
```

### example-6

```
"datetime-wtz"
```

### example-7

```
"decimal"
```

### example-8

```
"double"
```

### example-9

```
"enum"
```

### example-10

```
"float"
```

### example-11

```
"integer"
```

### example-12

```
"integer-big"
```

### example-13

```
"integer-big-unsigned"
```

### example-14

```
"integer-medium"
```

### example-15

```
"integer-medium-unsigned"
```

### example-16

```
"integer-small"
```

### example-17

```
"integer-small-unsigned"
```

### example-18

```
"integer-tiny"
```

### example-19

```
"integer-tiny-unsigned"
```

### example-20

```
"integer-unsigned"
```

### example-21

```
"json"
```

### example-22

```
"number"
```

### example-23

```
"string"
```

### example-24

```
"text"
```

### example-25

```
"text-long"
```

### example-26

```
"text-medium"
```

### example-27

```
"time"
```

### example-28

```
"time-wtz"
```

### example-29

```
"timestamp"
```

### example-30

```
"timestamp-wtz"
```

### example-31

```
"uuid"
```

## unary

UNARY is an EXPRESSION which uses the first EXPRESSION to perform a unary operation.

[definitions](#definitions)

### example-1

```
{
   "unary" : {
      "plus" : 1000
   }
}
```

### example-2

```
{
   "unary" : {
      "plus" : {
         "column" : "amount"
      }
   }
}
```

### example-3

```
{
   "unary" : {
      "minus" : 1000
   }
}
```

### example-4

```
{
   "unary" : {
      "minus" : {
         "column" : "amount"
      }
   }
}
```

## update

UPDATE changes the values of the specified columns in all rows that satisfy the condition.

[definitions](#definitions)

### example-1

```
{
   "update" : {
      "columns" : [
         {
            "column" : "login",
            "value" : "admin"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "where" : [
         {
            "not-null" : {
               "column" : "verified"
            }
         }
      ]
   }
}
```

### example-2

```
{
   "update" : {
      "columns" : [
         {
            "column" : "login",
            "value" : "admin"
         },
         {
            "column" : "password",
            "value" : "secret"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "where" : [
         {
            "eq" : [
               {
                  "column" : "id"
               },
               1
            ]
         }
      ]
   }
}
```

### example-3

```
{
   "update" : {
      "columns" : [
         {
            "column" : "login",
            "value" : "admin"
         },
         {
            "column" : "password",
            "value" : "secret"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "where" : [
         {
            "eq" : [
               {
                  "column" : "id"
               },
               {
                  "subquery" : {
                     "select" : {
                        "columns" : [
                           {
                              "function" : [
                                 "min",
                                 {
                                    "column" : "id"
                                 }
                              ]
                           }
                        ],
                        "from" : {
                           "table" : "users"
                        }
                     }
                  }
               }
            ]
         }
      ]
   }
}
```

### example-4

```
{
   "update" : {
      "columns" : [
         {
            "column" : "login",
            "value" : "admin"
         }
      ],
      "for" : {
         "table" : "users"
      },
      "returning" : [
         {
            "column" : "*"
         }
      ],
      "where" : [
         {
            "not-null" : {
               "column" : "verified"
            }
         }
      ]
   }
}
```

## verbatim

VERBATIM represents a built-in SQL keyword (and optional arguments).

[definitions](#definitions)

### example-1

```
{
   "verbatim" : [
      "NULL"
   ]
}
```

### example-2

```
{
   "verbatim" : [
      "NOT NULL"
   ]
}
```

### example-3

```
{
   "verbatim" : [
      "CURRENT_TIMESTAMP"
   ]
}
```

### example-4

```
{
   "verbatim" : [
      "TIMESTAMP",
      "2000-01-01 00:00:00"
   ]
}
```

## view-create

VIEW-CREATE defines a view of a query.

[definitions](#definitions)

### example-1

```
{
   "view-create" : {
      "name" : "active_users",
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "*"
               }
            ],
            "from" : {
               "table" : "users"
            },
            "where" : [
               {
                  "not-null" : {
                     "column" : "active"
                  }
               }
            ]
         }
      }
   }
}
```

### example-2

```
{
   "view-create" : {
      "name" : "active_users",
      "query" : {
         "select" : {
            "columns" : [
               {
                  "column" : "*"
               }
            ],
            "from" : {
               "table" : "users"
            },
            "where" : [
               {
                  "not-null" : {
                     "column" : "active"
                  }
               }
            ]
         }
      },
      "safe" : true,
      "temp" : true
   }
}
```

## view-drop

VIEW-DROP drops an existing view.

[definitions](#definitions)

### example-1

```
{
   "view-drop" : {
      "name" : "active_users"
   }
}
```

### example-2

```
{
   "view-drop" : {
      "name" : "active_users",
      "safe" : true
   }
}
```

# AUTHOR

Al Newkirk, @iamalnewkirk

# LICENSE

Copyright (C) 2020, Al Newkirk, et al.

This is free software; you can redistribute it and/or modify it under the terms
of the The Apache License, Version 2.0, as elucidated in the ["license
file"](https://github.com/iamalnewkirk/json-sql/blob/master/LICENSE).

# PROJECT

[Wiki](https://github.com/iamalnewkirk/json-sql/wiki)

[Project](https://github.com/iamalnewkirk/json-sql)

[Initiatives](https://github.com/iamalnewkirk/json-sql/projects)

[Milestones](https://github.com/iamalnewkirk/json-sql/milestones)

[Contributing](https://github.com/iamalnewkirk/json-sql/blob/master/CONTRIBUTE.md)

[Issues](https://github.com/iamalnewkirk/json-sql/issues)