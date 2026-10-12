from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions, TFCPS_CodeUnitSpecific_Flutter_CLI


def run_testcases():
    tf: TFCPS_CodeUnitSpecific_Flutter_Functions = TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    tf.run_testcases("mat_culture_selector")
    # Besides the widget-tests this codeunit has visual-regression-tests: they render the widget and compare the
    # resulting image with its baseline. That is what makes an unintended change of the appearance visible, which
    # a widget-test can not detect. They are excluded from the run above (see "dart_test.yaml" of the dart-package)
    # and are run here instead, inside a container (see
    # TFCPS_CodeUnitSpecific_Flutter_Functions.run_visual_regression_tests_in_container), so that their
    # baseline-comparison is reproducible independently of the operating-system this script runs on.
    tf.run_visual_regression_tests_in_container("mat_culture_selector", False)


if __name__ == "__main__":
    run_testcases()
