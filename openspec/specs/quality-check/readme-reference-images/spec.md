# readme-reference-images Specification

## Purpose

Defines the readme's example images of the component and the narrow exception which lets the codeunit's quality-check script write them outside its own codeunit folder.

## Requirements

### Requirement: Readme reference images are generated, not hand-drawn
The two example images referenced by `ReadMe.md` (`Other/Reference/Technical/Images/ThemeSwitcherLight.png` and `Other/Reference/Technical/Images/ThemeSwitcherDark.png`) SHALL always show the current appearance of the component. They SHALL be produced by `NgxDarkmodeToggleButton/Other/QualityCheck/UpdateVisualRegressionBaselines.py`, which regenerates them as a side effect of updating the visual-regression-baselines (`task uvrb`). Neither image SHALL be edited or replaced by hand.

The images SHALL be screenshots the visual-regression-testcases take of the demo-application, restricted to the chromium engine: the readme is meant to show one reproducible rendering, not one per browser engine.

#### Scenario: Baselines are regenerated
- **WHEN** `task uvrb` runs
- **THEN** both readme reference images are overwritten with a current, chromium-only screenshot of the component

#### Scenario: A normal test-run must not touch the readme images
- **WHEN** the visual-regression-testcases run without regenerating baselines (a normal `task bb` or CI run)
- **THEN** the readme reference images are left unchanged

### Requirement: The quality-check script may write outside its codeunit folder
A codeunit's scripts normally only modify files inside their own codeunit folder. `NgxDarkmodeToggleButton/Other/QualityCheck/UpdateVisualRegressionBaselines.py` is an explicit, narrow exception to that rule: it SHALL be permitted to write exactly the two files named in "Readme reference images are generated, not hand-drawn" under the repository-level `Other/Reference/Technical/Images`, and no other file outside its own codeunit folder.

#### Scenario: Script writes the readme images
- **WHEN** `UpdateVisualRegressionBaselines.py` copies a generated reference-image into `Other/Reference/Technical/Images`
- **THEN** this is expected, permitted behavior and not a defect to flag during review
