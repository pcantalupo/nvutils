# nvutils

## Testing

- Network access is reliable in this environment. Do not flag network-dependent tests as flaky, and do not add `skip_if_offline()` or `skip_on_cran()` to tests purely because they make network calls. This applies to the `getHomologousSymbols` tests, which fetch ortholog mappings through `orthogene::convert_orthologs`.
- When running a test smell review, state explicitly in the report that network-dependent flakiness is being ignored per this policy, rather than silently omitting it.
