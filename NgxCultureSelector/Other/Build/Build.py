import os
import shutil

from ScriptCollection.GeneralUtilities import GeneralUtilities
from ScriptCollection.TFCPS.NodeJS.TFCPS_CodeUnitSpecific_NodeJS import TFCPS_CodeUnitSpecific_NodeJS_Functions,TFCPS_CodeUnitSpecific_NodeJS_CLI


def build() -> None:
    tf: TFCPS_CodeUnitSpecific_NodeJS_Functions = TFCPS_CodeUnitSpecific_NodeJS_CLI.parse(__file__)
    tf.build()
    update_artifact(tf)


def update_artifact(tf: TFCPS_CodeUnitSpecific_NodeJS_Functions) -> None:
    """Puts the readme of the codeunit and the license of the repository into the built npm-package.

    npmjs.com shows the readme which is contained in the package on the page of the package, and ng-packagr only
    takes a readme which lies beside its "ng-package.json". Doing it here means that the codeunit keeps one single
    readme instead of a second one which would have to be maintained in parallel and would drift apart."""

    # The folder which "ng-package.json" writes the npm-package to.
    npm_package_artifact_name: str = "BuildResult_NPMPackage"

    # The branch whose state the published package refers to. It is used to make the links of the readme absolute.
    branch_of_published_state: str = "main"

    # The names under which npm expects the two files in a package.
    name_of_readme_in_package: str = "README.md"
    name_of_license_in_package: str = "LICENSE"

    repository_folder: str = tf.get_repository_folder()
    package_folder: str = os.path.join(tf.get_codeunit_folder(), "Other", "Artifacts", npm_package_artifact_name)
    GeneralUtilities.assert_folder_exists(package_folder)

    # On npmjs.com the readme is not shown in the context of the repository, so a relative link (for example the
    # one of the example-screenshot) can not be resolved there and the image would stay invisible. Therefore the
    # links which point into the repository are made absolute. The address is taken from the
    # product-information-file, so that a rename of the repository does not have to be repeated here.
    # Example: "https://github.com/anionDev/NgxCultureSelector" becomes
    # "https://raw.githubusercontent.com/anionDev/NgxCultureSelector/main/".
    address_of_raw_files: str = f"{tf.get_remote_address().replace('https://github.com/', 'https://raw.githubusercontent.com/')}/{branch_of_published_state}/"
    readme_content: str = GeneralUtilities.read_text_from_file(os.path.join(tf.get_codeunit_folder(), "ReadMe.md"))
    readme_content = readme_content.replace("](Other/", f"]({address_of_raw_files}{tf.get_codeunit_name()}/Other/")
    GeneralUtilities.write_text_to_file(os.path.join(package_folder, name_of_readme_in_package), readme_content)

    shutil.copyfile(os.path.join(repository_folder, "License.txt"), os.path.join(package_folder, name_of_license_in_package))


if __name__ == "__main__":
    build()
