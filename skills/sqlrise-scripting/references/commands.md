# SQLRise Command Reference For Script Authors

Use this as a portable syntax and boundary cheat sheet. Prefer repo-local
command docs when facts point to them.

## Script Execution

```sql
@script.sqlr positional... name=value
@@relative-child.sqlr positional... name=value
.start script.sqlr positional... name=value
```

- `@` runs a script from explicit path or script search path.
- `@@` resolves relative to the current script file and requires script context.
- `.start` is the word-command equivalent of `@`.
- Positional arguments must come before named arguments.
- Named arguments do not count toward `$1`, `$2`, or `$*`.
- Extensionless names consider `.sqlr` and `.sql`.
- Ambiguous matches fail instead of silently choosing.
- Slash commands such as `/run`, `/watch`, `/script`, and `/connect` are
  interactive prompt commands, not shared script commands.

## Metadata And Help

SQLRise reads leading `--` or `/* */` comments before the first SQL or SQLRise
command. Supported metadata keys:

```sql
param: schema default="" desc="optional schema name"
param: 1 desc="object name"
database_type: postgres, mysql, mariadb, sqlite
compatible: postgres, mysql, sqlite
tags: metadata inspection
destructive: false
see: @related-script
author: DBA Team
```

`usage:` remains visible help text but is not structured metadata. Defaults are
text substitutions. Prefer `default=""` plus explicit SQL conditions.

Help and discovery surfaces:

```sql
.help @script
@script ?
/script
/script list
/script find locks
/script which locks
```

`?` is help only when it is a bare final token.

## Variables And Substitution

Forms:

```text
$1, $2       positional parameters
$*           all positional parameters joined with spaces
${name}      named variable, parameter, or built-in
${!name}     trusted SQL text rewrite, SQL contexts only
\${name}     literal marker when backslash escape is active
```

Plain variables in SQL bind values through the provider driver. Do not wrap
plain SQL variables in single quotes. Use SQL concatenation or casts when the
database needs them.

Raw `${!name}` rewrites SQL text. Reserve it for trusted identifiers, qualified
object names, sort clauses, and script-built SQL fragments. It is rejected in
command/text contexts such as `.echo`, `.fail`, script targets, and script
arguments.

Built-ins include:

```text
${_DATE}
${_USER}
${_DATABASE}
${_DATABASE_TYPE}
${_DATABASE_COMPATIBILITY}
${_SCRIPT}
```

User variable names start with an ASCII letter and may contain ASCII letters,
digits, or underscores. Names are case-insensitive; values preserve text case.

## Value Sources

```sql
.define owner = public
.define
.undefine owner
.undefine ALL
```

`.define` stores text. `.define` with no arguments lists variables.

```sql
.accept env CHOICE dev,stage,prod DEFAULT dev PROMPT 'Environment: '
.accept confirmed BOOL DEFAULT false PROMPT 'Continue? '
.accept run_date DATE PROMPT 'Run date: '
.accept threshold NUMBER MIN 0 MAX 99.99 PROMPT 'Threshold: '
.accept rows INTEGER MIN 1 MAX 1000 DEFAULT 100 PROMPT 'Rows: '
.accept password SECRET PROMPT 'Password: '
```

`.accept` types check text and store normalized text. `SECRET` suppresses
terminal echo where available. `.accept` does not have database-aware schema,
table, column, identifier, or connection types.

```sql
.capture owner, table_name AS
SELECT table_schema, table_name
FROM information_schema.tables
LIMIT 1;

.capture ddl = "Create Table" AS
SHOW CREATE TABLE `${!schema}`.`${!object}`;
```

`.capture` requires exactly one row. Positional capture requires exactly the
same number of result columns as variables. Named-column capture allows extra
columns and fails on missing or ambiguous requested columns.

```sql
.foreach schema, table_name AS
SELECT table_schema, table_name
FROM information_schema.tables;

  .echo Checking ${schema}.${table_name}

.end foreach
```

`.foreach` runs the body once per returned row. Empty results skip the body.
Loop variables shadow outer variables only during each body run. `.end foreach`
does not use a semicolon.

## Conditionals And Requirements

```sql
.require DATABASE_TYPE postgres
.require COMPATIBLE mysql
.require VERSION >= 8.0
```

Use `.require` for assumptions that should stop the script.

```sql
.if DATABASE_TYPE = 'postgres'
  @@postgres/check
.else if COMPATIBLE = 'mysql'
  @@mysql/check
.else
  .fail Unsupported database: ${_DATABASE_TYPE}
.end if
```

`.if` expressions support `=`, `==`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `AND`,
`OR`, `NOT`, parentheses, and scalar `IN` / `NOT IN` lists. Ordered
comparisons require numeric operands. `IN` does not split variable values and
does not accept subqueries. Missing variables resolve to empty strings inside
conditions only. `${!raw}` is not supported inside `.if`.

Bare `IF`, `ELSE`, and `END IF` are database SQL, not SQLRise block commands.
`.end if` does not use a semicolon.

## Error, Exit, Repeat, Delimiter

```sql
.whenever error exit
.whenever error continue
```

This controls ordinary SQL statement failures and SQL-bearing command failures
from `.capture`, `.foreach`, `.repeat`, and `.export`. Syntax, substitution,
resolution, explicit `.fail` / `.error`, and other non-SQL command errors still
stop the current script.

```sql
.fail Unsupported database: ${_DATABASE_TYPE}
.error Missing required precondition
.exit SUCCESS
.exit FAILURE
.exit 7
```

`.fail` and `.error` are aliases. Messages substitute variables. `.exit` sets
script/process status.

```sql
.repeat every 5s for 1h
SELECT count(*) FROM jobs;
.end repeat
```

`.repeat` runs immediately, then waits between non-overlapping body runs until
the bounded `for` duration expires. `every` and `for` are required. Durations
are positive integers with optional `s`, `m`, or `h`. `.end repeat` does not
use a semicolon.

```sql
.delimiter //
...
.delimiter ;

.delimiter $$ FOR
...
$$
```

`.delimiter` changes statement boundary detection. SQLRise strips the custom
delimiter marker before sending SQL but does not rewrite procedural SQL.
`FOR` applies only to the next SQL statement.

## Output And Reporting

```sql
.echo Starting ${_SCRIPT} on ${_DATABASE}
.echo <<END
Database: ${_DATABASE}
Generated: ${_DATE}
END
```

`.prompt` is a backwards-compatible alias for `.echo`. Heredoc `.echo` is
script-text only.

Runtime script settings include:

```sql
.set PageLength 0
.set LineSize 132
.set LineSize AUTO
.set TextWidth 40
.set Wrap OFF
.set Null ''
.set ResultLayout TABLE
.set Pivot ON
.set Echo ON
.set Verify ON
.set TermOut OFF
.set TrimSpool ON
.unset TextWidth
.unset ALL
```

Inside scripts, `.set` changes are scoped to the script invocation and unwind
when the script returns. `.set` rejects personal preferences and path-list
settings such as color, editor, prompt style, notebook path, script path, and
connection sets. Notebook SQL blocks reject `.set` and `.unset`.

```sql
.column amount FORMAT $999,999,990.00 HEADING 'Amount' ALIGN RIGHT NULL 'n/a'
.column notes WORD_WRAPPED
.column path TRUNCATED
.column created_at FORMAT YYYY-MM-DD HH24:MI:SS.FF3 TZH:TZM
.column customer_name HEADING 'Customer|Name'
.column username CLEAR
.clear COLUMNS
```

`.column` rules match result columns case-insensitively. It formats displayed
columns only; use SQL projection to omit columns.

```sql
.break ON department
.break ON customer_name, order_number
.compute SUM OF salary ON department
.compute COUNT OF employee_id ON department
.compute AVG OF salary ON REPORT
.clear BREAKS
.clear COMPUTES
.clear ALL
```

Queries must order rows by break columns for stable grouped output. `SUM` and
`AVG` require numeric values. `COUNT` counts non-null values in the named
column.

## Spool And Export

```sql
.spool report.txt
.spool REPLACE report.txt
.spool APPEND report.txt
.spool OFF
```

`.spool file` creates a new file and fails if it already exists. `REPLACE`
overwrites. `APPEND` appends or creates. Spool output is plain text and ANSI
free. `.set TrimSpool ON` trims trailing spaces.

```sql
.export QUERY TO sessions.csv FORMAT CSV AS
SELECT pid, usename, state
FROM pg_stat_activity;

.export REPLACE QUERY TO sessions.json FORMAT JSON AS
SELECT pid, usename, state
FROM pg_stat_activity;
```

Formats: `CSV`, `TSV`, `JSON`, `YAML`, `YML`. `.export` owns one query and does
not use report formatting, spooling, or result layout. `APPEND` is unsupported.

## Comments And Host Commands

SQLRise preserves standard SQL comments inside executable SQL and ignores
standalone SQL comments during script command classification. `#` comments are
SQLRise script-only comments and are stripped before SQL execution.

```sql
! pwd
.host ls -la
```

`!` and `.host` run local OS commands. SQLRise does not substitute SQLRise
variables or script parameters in host command text; `$` and `${...}` belong to
the shell. Treat host commands in scripts as code that needs review.

