from ScriptCollection.TFCPS.NodeJS.TFCPS_CodeUnitSpecific_NodeJS import TFCPS_CodeUnitSpecific_NodeJS_Functions,TFCPS_CodeUnitSpecific_NodeJS_CLI
from ScriptCollection.TFCPS.TFCPS_VisualRegressionTests import TFCPS_VisualRegressionTests


def run_testcases():
    tf:TFCPS_CodeUnitSpecific_NodeJS_Functions=TFCPS_CodeUnitSpecific_NodeJS_CLI.parse(__file__)
    tf.run_testcases()
    # Besides the unit-tests this codeunit has visual-regression-tests: they open the demo-application and
    # compare a screenshot of it with the baseline of the same browser. That is what makes an unintended change
    # of the appearance of the component visible, which a unit-test can not detect.
    TFCPS_VisualRegressionTests(tf).run(False)


if __name__ == "__main__":
    run_testcases()
