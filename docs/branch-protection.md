# Branch Protection

To configure repository protections:

1. Enable "Workflow permissions: Read and write" in **Settings → Actions → General**.
2. Protect the `main` branch with:
   - Required status checks: `ci` and `black-guard`.
   - At least one approving review (self-review allowed).
   - Enforce rules for administrators.
   - Enable auto-merge.
