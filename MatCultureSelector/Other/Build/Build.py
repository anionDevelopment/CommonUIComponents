from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions,TFCPS_CodeUnitSpecific_Flutter_CLI


def build():
    tf:TFCPS_CodeUnitSpecific_Flutter_Functions=TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    # No target is built because a dart-package is published as sourcecode and therefore has no compiled
    # build-result. The readme of this codeunit as well as the license and the changelog of the repository are put
    # into the package, because pub.dev shows that readme and that changelog on the page of the package and expects
    # the license to be part of the package.
    tf.build("mat_culture_selector",[],add_readme_of_codeunit_to_package=True,add_license_of_repository_to_package=True,add_changelog_of_repository_to_package=True)


if __name__ == "__main__":
    build()
