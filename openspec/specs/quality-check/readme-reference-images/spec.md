# readme-reference-images Specification

## Purpose

Defines the example-pictures which the readme of a code-unit shows: they are generated from what the
visual-regression-tests render, so they show the component as it really looks instead of as it looked when
somebody last took a screenshot by hand.

## Requirements

### Requirement: The example-pictures of a readme are generated, not hand-drawn

Every code-unit of this repository SHALL show its component in at least one picture in its readme
(`<Code-unit>/ReadMe.md`), and every one of those pictures SHALL lie in
`<Code-unit>/Other/Reference/Technical/Images`.

Those pictures SHALL be produced by `<Code-unit>/Other/QualityCheck/UpdateVisualRegressionBaselines.py`, which
writes them as a side-effect of regenerating the visual-regression-baselines (`task uvrb-<kind>-<component>`).
Neither picture SHALL be edited or replaced by hand.

For a code-unit whose visual-regression-tests render in more than one browser-engine, the pictures SHALL be the
ones of the chromium-engine: a readme shows one reproducible rendering, not one per engine.

#### Scenario: Baselines are regenerated

- **WHEN** the visual-regression-baselines of a code-unit are regenerated
- **THEN** the example-pictures of that code-unit's readme are overwritten with a current rendering of the
  component

#### Scenario: A normal test-run must not touch the example-pictures

- **WHEN** the visual-regression-tests run without regenerating baselines (a normal build or a pipeline-run)
- **THEN** the example-pictures are left unchanged

#### Scenario: A component changes its appearance

- **WHEN** the appearance of a component changes on purpose
- **THEN** the baselines and the example-pictures of its code-unit are regenerated in the same step, so the readme
  can not show a state of the component which does not exist any more
