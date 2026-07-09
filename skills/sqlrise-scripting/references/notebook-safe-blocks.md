# Notebook-Safe SQL Blocks

Use this reference when writing SQLRise commands inside notebook SQL blocks or
when converting terminal scripts into notebook-safe snippets.

## Safe Subset

Notebook SQL blocks support ordinary SQL plus this SQLRise subset:

```text
.echo
.define
.undefine
.capture
.delimiter
.require
.if
.else if
.else
.end if
.foreach
.end foreach
.repeat
.end repeat
.fail
.error
```

`.echo` is accepted as a no-op in notebook SQL blocks. Use Markdown blocks for
visible notebook notes.

`.capture` and `.foreach` queries are control input. They store variables or
loop rows but do not render their own result tables. Add ordinary `SELECT`
statements when the reader needs visible evidence.

```sql
.capture high_ticket_count AS
SELECT COUNT(*)
FROM support_tickets
WHERE priority = 'high'
  AND ticket_status <> 'closed';

SELECT 'Open high-priority tickets' AS metric,
       ${high_ticket_count} AS value;
```

## Rejected Commands

Notebook SQL blocks reject prompt-only, host-side, external-script, slash
workflow, script SQL-error policy, exit-status, CLI session setting, and
terminal report commands, including:

```text
.accept
.host
!
@
@@
.start
.set
.unset
.column
.clear
.break
.compute
.whenever
.exit
/script and other slash commands
```

`.spool` and `.export` may appear in skipped branches, but fail if execution
reaches them. Notebook SQL blocks do not write local report or export files.
Use notebook save, print, browser copy/export actions, or separate terminal
scripts for file-output workflows.

Use Form blocks for visible `.accept`-style inputs.

## Execution And Evidence

Notebook SQL blocks may contain multiple SQL statements separated by
SQLRise-supported statement boundaries. They execute in source order and keep
every produced statement output. Earlier results are not hidden just because a
later statement also produced a result set.

Because notebook SQL blocks reject `.whenever`, a database error stops the
block at the failing statement, marks the block failed, and preserves already
produced outputs plus the diagnostic. Validation errors fail before any
statement executes.

Use visible SQL for evidence:

```sql
.if DATABASE_TYPE = 'postgres'
SELECT current_database() AS database_name;
.else if COMPATIBLE = 'mysql'
SELECT DATABASE() AS database_name;
.else
  .fail Unsupported database: ${_DATABASE_TYPE}
.end if
```

## Delimiters

`.delimiter` affects statement splitting only inside the current notebook SQL
block. Delimiter state is restored after the block finishes, fails, or is
canceled.

A statement delimiter must be the final meaningful token for that statement.
Do not put additional SQL or SQLRise command input after the delimiter on the
same physical line.

Use one-shot delimiters when possible:

```sql
.delimiter // FOR
CREATE PROCEDURE refresh_rollups()
BEGIN
  SELECT 1;
END//
```

## Notebook-Safe Dispatch

Because notebook blocks cannot call `@`, `@@`, or `.start`, provider dispatch
must keep the SQL in block-local branches or use separate notebook blocks.

```sql
.if COMPATIBLE = 'postgres'
SELECT current_schema() AS schema_name;
.else if COMPATIBLE = 'mysql'
SELECT DATABASE() AS schema_name;
.else if COMPATIBLE = 'sqlite'
SELECT 'main' AS schema_name;
.else
  .fail Unsupported database compatibility: ${_DATABASE_COMPATIBILITY}
.end if
```

If the logic grows beyond a readable notebook block, move it to a normal
SQLRise script for terminal use or to a future script-backed notebook surface
only when repo facts say that surface is available.

## Review Checklist

- Are all commands in the notebook-safe subset?
- Does every `.capture` or `.foreach` control query have visible evidence when
  the reader needs it?
- Is input collected through Form blocks rather than `.accept`?
- Are file, host, external script, slash, setting, report, and exit commands
  absent from executed paths?
- Are provider branches short enough to read inside one SQL block?
- Are repeated outputs from `.repeat` compact and bounded?
- Are explanatory notes in Markdown, not `.echo`?

