## Why

`NgxCultureSelector/Other/QualityCheck/UpdateVisualRegressionBaselines.py` writes the readme's example images into `Other/Reference/Technical/Images`, which lives outside the `NgxCultureSelector` codeunit folder the script itself belongs to. A script modifying files outside its own codeunit is normally unintended and would be a bug if found during review. This exception was previously documented as a note in `ReadMe.md`; it belongs in a spec instead, since it is a rule about permitted system behavior, not end-user documentation.

## What Changes

- Document, as a spec requirement, that `UpdateVisualRegressionBaselines.py` is explicitly permitted to write the two readme reference images (`Other/Reference/Technical/Images/CultureSelectorClosed.png` and `Other/Reference/Technical/Images/CultureSelectorOpen.png`) even though they live outside the codeunit folder.
- Remove the corresponding note from `ReadMe.md`.

## Capabilities

### New Capabilities
- `quality-check/readme-reference-images`: defines which files `UpdateVisualRegressionBaselines.py` is permitted to write outside the codeunit folder, and how those images are produced (chromium-only, via the visual-regression-testcases, unconditionally overwritten).

### Modified Capabilities

## Impact

- `ReadMe.md`: the permission note is removed.
- No code changes: `UpdateVisualRegressionBaselines.py` already implements exactly this behavior; this change only documents it in the correct place.
