from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions,TFCPS_CodeUnitSpecific_Flutter_CLI


def update_dependencies():
    tf:TFCPS_CodeUnitSpecific_Flutter_Functions=TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    tf.update_dependencies()


if __name__ == "__main__":
    update_dependencies()
