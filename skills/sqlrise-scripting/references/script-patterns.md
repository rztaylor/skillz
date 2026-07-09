# SQLRise Script Patterns

## Table Of Contents

- Tiny dispatcher, provider helpers
- Scalar capture before branching
- Query-driven work lists
- Parameters and substitution
- Human reports, spools, exports
- Error policy, polling, delimiters
- Guarded destructive workflows
- Review checklist

## Tiny Dispatcher, Provider Helpers

Use a public wrapper for the user-facing command and provider children for real
SQL. This keeps each provider script testable and avoids fake portability.

```sql
.if COMPATIBLE = 'postgres'
  @@postgres/locks schema="${schema}"
.else if COMPATIBLE = 'mysql'
  @@mysql/locks schema="${schema}"
.else
  .fail Lock inspection is not available for ${_DATABASE_TYPE}
.end if
```

For direct folder routing, require the supported families first:

```sql
.require COMPATIBLE postgres,mysql,sqlite
@@${_DATABASE_COMPATIBILITY}/tables schema="${schema}" pattern="${pattern}"
```

Use explicit `.if` when unsupported providers need custom diagnostics, when
version branches matter, or when folder names do not match compatibility names.

Provider helpers should still own their contract:

```sql
.require COMPATIBLE postgres
```

## Branch To Exact SQL

When selected object type already tells you what the user wants, branch to the
exact provider-native statement instead of building one huge catalog query.

```sql
.if "${object_type}" = "trigger"
  .capture ddl = "SQL Original Statement" AS
  SHOW CREATE TRIGGER `${!schema}`.`${!object}`;

  SELECT ${ddl} AS "Trigger DDL";
.else if "${object_type}" = "procedure"
  .capture ddl = "Create Procedure" AS
  SHOW CREATE PROCEDURE `${!schema}`.`${!object}`;

  SELECT ${ddl} AS "Procedure DDL";
.else
  .fail Unsupported object type for definition: ${object_type}
.end if
```

Named-column `.capture` is the bridge from wide provider-native output into a
clean script result. Quote returned column selectors that contain spaces or
punctuation.

```sql
.capture create_table = "Create Table" AS
SHOW CREATE TABLE `${!schema}`.`${!object}`;

SELECT ${create_table} AS ddl;
```

## Scalar Capture Before Branching

`.if` is scalar. Put set logic in SQL and capture one decision value.

```sql
.capture schema_exists AS
SELECT CASE WHEN EXISTS (
  SELECT 1
  FROM information_schema.schemata
  WHERE schema_name = ${schema}
) THEN 'true' ELSE 'false' END;

.if ${schema_exists} = 'true'
  @@schema-checks schema="${schema}"
.else
  .fail Schema not found: ${schema}
.end if
```

Use the same pattern for "feature enabled", "blocker found", "row count over
threshold", "object supports this tab", or "version capability present".

## Query-Driven Work Lists

Use `.foreach` when the database owns the work list.

```sql
.foreach schema = table_schema, object = table_name AS
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = ${schema}
  AND table_name LIKE ${pattern}
ORDER BY table_schema, table_name;

  .echo Inspecting ${schema}.${object}
  @@tab-ind object="${object}" schema="${schema}"

.end foreach
```

Before expensive or destructive loop bodies, show the discovery query or print
each object. Narrow broad filters before action.

## Parameters And Substitution

Use metadata as the script UI.

```sql
/*
 * Open ticket queue
 *
 * usage: @open-ticket-queue priority=high open_only=true
 * param: priority default="" desc="optional priority filter"
 * param: open_only default="true" desc="true to hide closed tickets"
 * compatible: postgres, mysql
 * destructive: false
 */
```

Named defaults are text. For optional filters, use an empty default and an
explicit bypass condition:

```sql
WHERE (${priority} = '' OR priority = ${priority})
  AND (${open_only} = 'false' OR ticket_status <> 'closed')
```

Support compact prompt shorthand and named clarity when useful:

```sql
@.definition orders
@.definition object=orders schema=public object_type=table
```

Choose precedence deliberately. Named values often win over positional
shorthand:

```sql
WITH params AS (
    SELECT COALESCE(NULLIF(${object}, ''), NULLIF($1, '')) AS object_name,
           COALESCE(NULLIF(${schema}, ''), current_schema()) AS schema_name
)
```

If mixing both is risky, reject conflicts:

```sql
.if "${object}" <> "" AND "$1" <> "" AND "${object}" <> "$1"
  .fail Pass either positional object or object=, not conflicting values.
.end if
```

Remember:

- Positional arguments come before named arguments.
- Named parameters do not count toward `$1`, `$2`, or `$*`.
- Named script parameters shadow stored variables while the script runs.
- Named parameters do not automatically flow to nested scripts; pass them.
- Positional defaults are not applied from metadata.
- Missing positional parameters become empty strings.

## Treat Substitution As A Type Boundary

Plain variables in SQL are bind values:

```sql
WHERE table_schema = ${schema}
```

Raw `${!name}` rewrites SQL text and should be rare, visible, and trusted:

```sql
SHOW CREATE TABLE `${!schema}`.`${!object}`;
SELECT COUNT(*) FROM ${!qualified_table};
ORDER BY ${!order_by}
```

Use raw substitution for identifiers, qualified object names, sort clauses, or
script-built SQL fragments. Do not use it for ordinary user text. Never
raw-substitute an unchecked caller value directly into `ORDER BY`.

Trusted fragment pattern:

```sql
.if "${sort}" = "size"
  .define order_by = total_mb DESC
.else if "${sort}" = "name"
  .define order_by = object_name ASC
.else
  .fail Unsupported sort: ${sort}
.end if

SELECT object_name, total_mb
FROM object_sizes
ORDER BY ${!order_by};

.undefine order_by
```

Use `.set Verify ON` or `.set Echo ON` only while debugging substitution, then
remove or tightly scope them.

## Human Reports, Spools, Exports

Use report formatting for people:

```sql
.set LineSize 140
.set TextWidth 50
.column customer_name HEADING "Customer" FORMAT A28
.spool REPLACE triage.txt

SELECT customer_name, subject, opened_at
FROM support_tickets
ORDER BY opened_at;

.spool OFF
```

Use `.export` for one structured query result:

```sql
.export REPLACE QUERY TO triage.json FORMAT json AS
SELECT ticket_id, priority, subject
FROM support_tickets
WHERE ticket_status <> 'closed';
```

Put report and export queries near each other when they describe the same
check. `.spool` captures rendered output; `.export` ignores report formatting.

## Error Policy, Polling, Delimiters

Default important scripts to stop on SQL errors:

```sql
.whenever error exit
@@must-pass-preflight

.whenever error continue
@@best-effort-extra-context

.whenever error exit
@@next-required-check
```

Use bounded polling for safe operational checks:

```sql
.repeat every 30s for 10m
SELECT COUNT(*) AS queued_jobs
FROM jobs
WHERE status = 'queued';
.end repeat
```

Use one-shot delimiters for procedural SQL with internal semicolons:

```sql
.delimiter // FOR
CREATE PROCEDURE refresh_rollups()
BEGIN
  CALL rebuild_daily_rollup();
  CALL rebuild_monthly_rollup();
END//
```

Delimiter changes inside `.if`, `.foreach`, and `.repeat` bodies do not leak
outside the block, but they affect later SQL inside that same body.

## Guarded Destructive Workflows

Make preview the default and require explicit intent for action.

```sql
/*
 * Delete draft orders
 *
 * param: mode default="preview" desc="preview or apply"
 * destructive: true
 */

.require COMPATIBLE postgres

SELECT order_id, order_status
FROM orders
WHERE order_status = 'draft';

.if "${mode}" = "apply"
  DELETE FROM orders WHERE order_status = 'draft';
.else if "${mode}" = "preview"
  .echo Preview only. Rerun with mode=apply to delete draft orders.
.else
  .fail mode must be preview or apply
.end if
```

Use `.accept` for interactive confirmation when a script is prompt-only. Use
named parameters for non-interactive repeatability.

## Review Checklist

- Can this be a tiny dispatcher plus provider helper?
- Is the script rebuilding data a provider-native command can return exactly?
- Could named-column `.capture` simplify wide provider output?
- Is `.if` choosing work, or trying to be SQL?
- Could SQL return one scalar to simplify a branch?
- Is `.foreach` the right way to turn rows into repeated checks?
- Are parameter defaults carrying the user-facing contract?
- Are optional values explicit about empty strings and SQL nulls?
- Is raw substitution limited to trusted identifiers or fragments?
- Should output be visible SQL, `.echo`, `.spool`, or `.export`?
- Is `.whenever error continue` scoped to optional evidence?
- Are procedural delimiters scoped to the smallest possible statement/body?
- In notebooks, is every needed control query paired with visible evidence?
- For inspect scripts, is this exact-object inspection or broad discovery?

