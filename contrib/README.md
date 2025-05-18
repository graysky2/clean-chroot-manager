### Dependency test
To test the internal repo, use ccm to build the package `foo` first and then the package `bar`
* `bar` has a dependency of `foo` so if something is not right, ccm will fail to build `bar`:
```
...
==> Making package: test-bar 1-1 (Sun May 18 05:12:50 2025)
==> Retrieving sources...
==> Making package: test-bar 1-1 (Sun May 18 09:12:52 2025)
==> Checking runtime dependencies...
==> Installing missing dependencies...
error: target not found: test-foo
==> ERROR: 'pacman' failed to install missing dependencies.
==> Missing dependencies:
  -> test-foo
==> Checking buildtime dependencies...
==> ERROR: Could not resolve all dependencies.
```
