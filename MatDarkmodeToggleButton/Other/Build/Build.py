from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions,TFCPS_CodeUnitSpecific_Flutter_CLI


def build():
    tf:TFCPS_CodeUnitSpecific_Flutter_Functions=TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    tf.build("mat_darkmode_toggle_button",[])


if __name__ == "__main__":
    build()
