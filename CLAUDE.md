# nvutils

## Testing

- Local network access is reliable in this environment. Do not flag network-dependent tests as flaky, and do not add `skip_if_offline()` or `skip_on_cran()` to tests purely because they make network calls. This applies to the `getHomologousSymbols` tests, which fetch ortholog mappings through `orthogene::convert_orthologs`.
- The g:Profiler service behind `orthogene::convert_orthologs` does return intermittent `HTTP 408` errors, which surface as an error in `test-getHomologousSymbols.R` rather than a failed expectation. This is a remote-side timeout, not a local connectivity problem and not a defect in the code under test. Re-run the file; it passes on retry. Do not respond by adding skips or by treating the run as a real failure.
- When running a test smell review, state explicitly in the report that network-dependent flakiness is being ignored per this policy, rather than silently omitting it.
