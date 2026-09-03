from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions,TFCPS_CodeUnitSpecific_Flutter_CLI
from VisualRegressionContainer import run_visual_regression_tests


def run_testcases():
    tf:TFCPS_CodeUnitSpecific_Flutter_Functions=TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    tf.run_testcases("mat_culture_selector")
    # Besides the widget-tests this codeunit has visual-regression-tests: they render the widget and compare the
    # resulting image with its baseline. That is what makes an unintended change of the appearance visible, which
    # a widget-test can not detect. They are excluded from the run above (see "dart_test.yaml" of the dart-package)
    # and are run here instead, inside a container, so that their baseline-comparison is reproducible independently
    # of the operating-system this script runs on. See "VisualRegressionContainer.py".
    run_visual_regression_tests(tf, False)


if __name__ == "__main__":
    run_testcases()
