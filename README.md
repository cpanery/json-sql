# JSON-SQL

JSON-SQL is a specification which defines a standard, database-vendor-agnostic
common SQL statement description (and JSON representation). This is a
specification aims to be a standards-compliant, e.g. SQL-92, and allow for the
development of better SQL statement generation, libraries, object-mappers, and
other tooling. The specification is a valid JSON Schema document which can be
validated using any JSON Schema validator with support for
_"https://json-schema.org/draft/2019-09/schema"_.

## Features

- vendor-agnostic
- language-agnostic
- sql as a data exchange format
- pre-flight sql statement syntax validation
- common sql coverage (99.999% standards-compliant)

## Demonstration

**Note:** Parser and SQL statement generation not included!

This example JSON-SQL data structure:

```
{
   "table-create" : {
      "name" : "removed_users",
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
CREATE TEMPORARY TABLE IF NOT EXISTS removed_users AS (
  SELECT * FROM users WHERE deleted IS NOT NULL
)
```

## Definitions

- [binary](#binary)
- [binding](#binding)
- [case](#case)
- [cast](#cast)
- [column](#column)
- [column-create](#column-create)
- [column-rename](#column-rename)
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
- [criterion-is-null](#criterion-is-null)
- [criterion-like](#criterion-like)
- [criterion-lt](#criterion-lt)
- [criterion-lte](#criterion-lte)
- [criterion-ne](#criterion-ne)
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
- [table](#table)
- [table-create](#table-create)
- [table-drop](#table-drop)
- [table-rename](#table-rename)
- [transaction](#transaction)
- [type](#type)
- [unary](#unary)
- [update](#update)
- [view-create](#view-create)
- [view-drop](#view-drop)

## binary

BINARY is an EXPRESSION which uses the first and second EXPRESSION to perform a binary operation.

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

### example-1

```
{
   "bind" : "token"
}
```

### example-2

```
{
   "bind" : "uuid"
}
```

## case

CASE is an EXPRESSION which provides a mechanism for declaring conditional expressions.

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
         "func" : [
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

## column-create

COLUMN-CREATE changes the definition of an existing table by adding a new column.

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
         "name" : "id",
         "nullable" : false,
         "primary" : true,
         "sequence" : true,
         "type" : "integer"
      },
      "for" : {
         "table" : "users"
      }
   }
}
```

## column-rename

COLUMN-RENAME changes the definition of an existing table by renaming a new column.

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

## constraint-create

CONSTRAINT-CREATE changes the definition of an existing table by adding a new foreign-key constraint.

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

## constraint-drop

CONSTRAINT-DROP removes an existing foreign-key constraint.

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
      "name" : "fkey_users_profile_id"
   }
}
```

## criteria

CRITERIA is a set of rules (criterion) which can be combined to create conditions and clauses which filter SQL datasets.

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

## criterion-and

CRITERION-AND is a criterion which represents a condition which joins the CRITERIA provided using the "AND" operator.

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
         "func" : [
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
         "func" : [
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
         "func" : [
            "datetime",
            1092941466,
            "unixepoch"
         ]
      },
      {
         "func" : [
            "date",
            "now"
         ]
      }
   ]
}
```

## criterion-eq

CRITERION-EQ is a criterion which represents an "equal" comparison operation.

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

## criterion-is-null

CRITERION-IS-NULL is a criterion which represents an "is null" comparison operation.

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

## criterion-not-null

CRITERION-NOT-NULL is a criterion which represents an "is not null" comparison operation.

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

## expression

EXPRESSION represents a valid SQL expression.

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
   "func" : [
      "true"
   ]
}
```

### example-4

```
{
   "func" : [
      "false"
   ]
}
```

### example-5

```
{
   "bind" : "login"
}
```

### example-6

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

### example-7

```
{
   "unary" : {
      "plus" : 1
   }
}
```

### example-8

```
{
   "cast" : [
      12.34,
      "int"
   ]
}
```

### example-9

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

## function

FUNCTION is an EXPRESSION which represents a built-in SQL function.

### example-1

```
{
   "func" : [
      "true"
   ]
}
```

### example-2

```
{
   "func" : [
      "false"
   ]
}
```

### example-3

```
{
   "func" : [
      "date",
      "now"
   ]
}
```

## index-create

INDEX-CREATE changes the definition of an existing table by adding a new column index.

### example-1

```
{
   "index-create" : {
      "column" : "email",
      "table" : "users"
   }
}
```

### example-2

```
{
   "index-create" : {
      "column" : "email",
      "name" : "indx_users_email",
      "table" : "users"
   }
}
```

### example-3

```
{
   "index-create" : {
      "column" : "email",
      "name" : "indx_uni_users_email",
      "table" : "users",
      "unique" : true
   }
}
```

## index-drop

INDEX-DROP removes an existing new column index.

### example-1

```
{
   "index-drop" : {
      "column" : "email",
      "table" : "users"
   }
}
```

### example-2

```
{
   "index-drop" : {
      "column" : "email",
      "name" : "indx_users_email",
      "table" : "users"
   }
}
```

### example-3

```
{
   "index-drop" : {
      "name" : "indx_users_email"
   }
}
```

## insert

INSERT inserts new rows into a table.

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

## literal

LITERAL represents acceptable raw SQL data types.

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

## schema-create

SCHEMA-CREATE enters a new schema into the current database.

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
            "func" : [
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
            "func" : [
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
                  "func" : [
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

## table

TABLE represents a DATABASE table reference.

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

### example-1

```
{
   "table-create" : {
      "columns" : [
         {
            "name" : "id",
            "primary" : true,
            "sequence" : true,
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
            "name" : "id",
            "primary" : true,
            "sequence" : true,
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

## table-drop

TABLE-DROP removes tables from the database.

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

## transaction

TRANSACTION represents a set of valid SQL statements to be executed within a database transaction.

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

### example-1

```
"string"
```

### example-2

```
"number"
```

### example-3

```
"integer"
```

### example-4

```
"integer-big"
```

## unary

UNARY is an EXPRESSION which uses the first EXPRESSION to perform a unary operation.

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

## view-create

VIEW-CREATE defines a view of a query.

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