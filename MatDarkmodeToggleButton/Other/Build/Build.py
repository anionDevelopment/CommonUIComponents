from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions,TFCPS_CodeUnitSpecific_Flutter_CLI


def build():
    tf:TFCPS_CodeUnitSpecific_Flutter_Functions=TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    tf.build("mat_darkmode_toggle_button",[],add_readme_of_codeunit_to_package=True,add_license_of_repository_to_package=True,add_changelog_of_repository_to_package=True)


if __name__ == "__main__":
    build()
