# ui-components Specification

## Purpose

States which user-interface-components this repository contains, in which form each of them exists and which
design all of them are built in. It is what makes the repository one product instead of a folder of unrelated
libraries: a component is offered to angular- and to flutter-applications alike, and both of them get the same
control.

## Requirements

### Requirement: The repository contains one entry per user-interface-component

This repository SHALL contain the following user-interface-components:

- country-selector
- culture-selector
- darkmode-toggle-button

The list MAY be extended by further components whenever one is needed; a component which is added follows the
requirements below like the ones which are already there.

#### Scenario: A component is added

- **WHEN** a further user-interface-component is developed in this repository
- **THEN** it is added to the list above and exists in the two code-units the next requirement demands

#### Scenario: A component is looked for

- **WHEN** an application needs one of the components of the list
- **THEN** it is part of this repository and does not have to be written again next to it

### Requirement: Every component exists as an angular- and as a flutter-code-unit

Every user-interface-component of this repository SHALL exist in exactly two code-units: one `Ngx`-code-unit whose
build-artifact is an angular-component-library, and one `Mat`-code-unit whose build-artifact is a dart-library.

The two code-units of one component SHALL offer the same thing as far as their platforms allow it: the same
purpose, the same options, the same result. Where a platform makes an exact equivalent impossible, the difference
SHALL be a documented decision of that code-unit and not an accident.

#### Scenario: A component is developed

- **WHEN** a user-interface-component of this repository is developed
- **THEN** both of its code-units exist, and each of them is published as the library of its platform

#### Scenario: A component gains an option

- **WHEN** one code-unit of a component gains an option, a behaviour or a default
- **THEN** the other code-unit of that component gains it as well, or states why its platform does not allow it

### Requirement: Every code-unit uses material design

Every code-unit of this repository SHALL build its component in material design: the angular-ones on Angular
Material, the flutter-ones on the material-widgets of Flutter.

A component SHALL take its colors, its typography and its density from the material-theme of the application which
uses it, so that it looks like the rest of that application instead of bringing an appearance of its own.

#### Scenario: A component is built

- **WHEN** a component of this repository is built or changed
- **THEN** it is built on the material-widgets of its platform and uses no hard-coded colors
