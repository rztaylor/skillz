# SQLRise Inspect Pack Conventions

Use this reference when writing or reviewing SQLRise-owned `@.` inspection
scripts. Always take the actual pack location, validation commands, changelog
policy, and test policy from repo-local facts.

## Shape Of A Built-In Family

The `@.` namespace is reserved for SQLRise-owned built-ins. Filesystem scripts
cannot shadow these inspection commands.

Each public built-in should have a small wrapper at the pack root:

```sql
@.find
@.tables
@.views
@.tab_ddl
```

The wrapper owns:

- short description and help text
- public parameter names
- examples
- required-argument validation
- provider routing

Provider-specific scripts live below provider folders. They own provider SQL
and result shape. They should not redefine the public UX in a different voice.

Wrapper routing pattern:

```sql
.if "$1" = ""
  .fail @.find requires a search term. Try @.find orders
.end if

.if COMPATIBLE = 'postgres'
  @@postgres/find "$1" schema="${schema}"
.else if COMPATIBLE = 'mysql'
  @@mysql/find "$1" schema="${schema}"
.else if COMPATIBLE = 'sqlite'
  @@sqlite/find "$1" schema="${schema}"
.else
  .echo No built-in object search script is available for ${_DATABASE_TYPE}.
  .fail Unsupported database compatibility: ${_DATABASE_COMPATIBILITY}
.end if
```

Provider children start with an explicit guard:

```sql
.require COMPATIBLE postgres
```

## Metadata And Parameters

Start every script with user-facing help, not implementation notes.

```sql
/*
 * Find database objects by name
 *
 * Search schemas, tables, views, indexes, routines, and triggers visible to
 * the active connection. Use % and _ for SQL LIKE wildcards.
 *
 * usage: @.find search-term [schema=pattern]
 *
 * examples:
 *   @.find orders
 *   @.find ord% schema=sales
 *
 * Parameters:
 *   param: 1 desc="Search term"
 *   param: schema default="" desc="Schema/database"
 *
 * tags: metadata search catalog inspection built-in
 * database_type: postgres, mysql, mariadb, sqlite
 * compatible: postgres, mysql, sqlite
 */
```

Prefer one public parameter contract per family. Use positional parameters for
primary search text when it matches prompt ergonomics, and named parameters for
optional filters such as `schema=`.

Validate required input in the wrapper before routing. Diagnostics should say
what is missing and the shortest useful recovery path.

## Broad Discovery Versus Exact Object

Discovery scripts may search or pattern-match:

```text
@.find
@.schemas
@.objects
@.tables
@.views
@.indexes
@.scheduled_tasks
```

Exact-object scripts inspect one selected object in the current or supplied
schema/database:

```text
@.columns
@.constraints
@.desc
@.describe
@.triggers
@.partitions
@.storage
@.routine
@.sequence
@.scheduled_task
@.ind_cols
@.trg_details
@.tab_ddl
@.view_ddl
@.ind_ddl
@.func_ddl
@.proc_ddl
@.trg_ddl
@.seq_ddl
@.task_ddl
```

Object-tab scripts must inspect exactly the selected object. Do not treat
object names or schemas as wildcard, LIKE, or regex patterns. If `schema=` is
omitted, use the provider's current schema/database, not every schema.

Notebook object-tab result sets should avoid repeating identity columns such
as schema, table, or object name unless a provider edge case needs them.

## Provider SQL And Result Columns

There is no required single output shape across providers. A family should
answer the same user question, but each provider child should return the facts
that provider exposes well.

Prefer clear reader-facing headings:

```sql
SELECT object_type AS "type",
       object_schema AS "schema",
       object_name AS "name",
       details
```

Avoid implementation-shaped headings when direct headings such as `type`,
`schema`, `name`, `owner`, `engine`, `estimated_rows`, `tablespace`,
`collation`, or `ddl` are clearer.

Use provider-native DDL sources when they answer exactly:

- MySQL/MariaDB `SHOW CREATE TABLE`, `SHOW CREATE TRIGGER`,
  `SHOW CREATE PROCEDURE`, `SHOW CREATE FUNCTION`
- PostgreSQL catalog functions such as `pg_get_functiondef` and
  `pg_get_triggerdef`, or carefully built catalog output when no single native
  DDL command exists
- SQLite stored `sqlite_schema.sql`

For wide native command output, use named-column `.capture`:

```sql
.capture sqlrise_ddl = "Create Table" AS
SHOW CREATE TABLE `${!schema}`.`${!object}`;

SELECT ${sqlrise_ddl} AS ddl;
.undefine sqlrise_ddl
```

Order output deterministically. Use stable, scan-friendly ordering such as
type, schema, name when the provider allows it.

## Safety Rules

Inspection scripts must be read-only. Do not add:

- DDL or DML
- `.host` or `!`
- `.spool` or `.export`
- secret prompts
- destructive SQL
- broad row samples
- hidden side effects
- session setting changes unless the command is explicitly about settings

Do not flatten provider-specific capability into a lowest-common-denominator
table only for symmetry. Preserve useful provider differences.

## Cleanup Checklist

1. Rewrite public wrapper help first.
2. Choose one public parameter contract and remove obsolete aliases.
3. Update every provider child to the same contract.
4. Keep provider children guarded with `.require`.
5. Choose provider-appropriate result columns and user-facing headings.
6. Remove misleading empty details and low-value placeholders.
7. Make required-argument errors actionable.
8. Check script discovery/help and representative script runs using repo facts.
9. Update docs, changelog, and tests only according to repo facts.

