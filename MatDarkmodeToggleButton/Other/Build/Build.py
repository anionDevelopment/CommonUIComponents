import os
import re
import shutil

from ScriptCollection.GeneralUtilities import GeneralUtilities
from ScriptCollection.ScriptCollectionCore import ScriptCollectionCore
from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions, TFCPS_CodeUnitSpecific_Flutter_CLI

# The name of the flutter-package inside this codeunit.
_package_name: str = "mat_darkmode_toggle_button"

# The folder which contains the package as it is published to pub.dev. It is created from the SourceCode-artifact
# (see build()), so that the published package can not contain anything which is not part of the repository.
_pub_package_artifact_name: str = "BuildResult_PubPackage"

# The branch whose state the published package refers to. It is used to make the links of the readme absolute.
_branch_of_published_state: str = "main"

# The names under which pub.dev expects these files in a package.
_name_of_readme_in_package: str = "README.md"
_name_of_license_in_package: str = "LICENSE"
_name_of_changelog_in_package: str = "CHANGELOG.md"


def build() -> None:
    tf: TFCPS_CodeUnitSpecific_Flutter_Functions = TFCPS_CodeUnitSpecific_Flutter_CLI.parse(__file__)
    # This codeunit is a library, so it has no platform-target: its build-result is its sourcecode (see the
    # HowToBuild.md of this codeunit).
    tf.build(_package_name, [])
    create_pub_package_artifact(tf)


def create_pub_package_artifact(tf: TFCPS_CodeUnitSpecific_Flutter_Functions) -> None:
    """Creates the folder which is published to pub.dev and verifies that it is publishable.

    The folder is the package as it is contained in the SourceCode-artifact, plus the three files pub.dev expects
    beside the sourcecode: the readme, the license and the changelog. Those three are not maintained inside the
    package but are generated here from the files of the repository, so that the repository keeps one single
    readme, one single license and one single changelog instead of a second copy of each which would have to be
    maintained in parallel and would drift apart."""

    codeunit_folder: str = tf.get_codeunit_folder()
    repository_folder: str = tf.get_repository_folder()
    source_code_folder: str = os.path.join(codeunit_folder, "Other", "Artifacts", "SourceCode", _package_name)
    GeneralUtilities.assert_folder_exists(source_code_folder)
    package_folder: str = os.path.join(codeunit_folder, "Other", "Artifacts", _pub_package_artifact_name)
    GeneralUtilities.ensure_directory_does_not_exist(package_folder)
    GeneralUtilities.ensure_directory_exists(package_folder)
    GeneralUtilities.copy_content_of_folder(source_code_folder, package_folder)

    GeneralUtilities.write_text_to_file(os.path.join(package_folder, _name_of_readme_in_package), get_readme_for_package(tf))
    shutil.copyfile(os.path.join(repository_folder, "License.txt"), os.path.join(package_folder, _name_of_license_in_package))
    GeneralUtilities.write_text_to_file(os.path.join(package_folder, _name_of_changelog_in_package), get_changelog_for_package(repository_folder))

    assert_package_is_publishable(tf, package_folder)


def get_readme_for_package(tf: TFCPS_CodeUnitSpecific_Flutter_Functions) -> str:
    """Returns the readme of the repository with the links which point into the repository made absolute.

    On pub.dev the readme is not shown in the context of the repository, so a relative link (for example the one of
    the example-screenshot) can not be resolved there and the image would stay invisible. The address is taken from
    the product-information-file, so that a rename of the repository does not have to be repeated here. Example:
    "https://github.com/anionDev/MatDarkmodeToggleButton" becomes
    "https://raw.githubusercontent.com/anionDev/MatDarkmodeToggleButton/main/"."""
    address_of_raw_files: str = f"{tf.get_remote_address().replace('https://github.com/', 'https://raw.githubusercontent.com/')}/{_branch_of_published_state}/"
    readme_content: str = GeneralUtilities.read_text_from_file(os.path.join(tf.get_repository_folder(), "ReadMe.md"))
    return readme_content.replace("](Other/", f"]({address_of_raw_files}Other/")


def get_changelog_for_package(repository_folder: str) -> str:
    """Returns the changelog of the repository in the form pub.dev expects it: one file, newest version first.

    The changelog of the repository is one file per version (see the "work-with-common-project-structure"-skill),
    which is what the release-process writes; pub.dev instead shows a single "CHANGELOG.md" whose sections are the
    versions. Both are therefore the same content in two shapes, and this is the place which converts the one into
    the other."""
    changelog_folder: str = os.path.join(repository_folder, "Other", "Resources", "Changelog")
    GeneralUtilities.assert_folder_exists(changelog_folder)
    versions_with_content: dict[tuple[int, ...], tuple[str, str]] = dict()
    for file_name in os.listdir(changelog_folder):
        match = re.fullmatch(r"v(\d+)\.(\d+)\.(\d+)\.md", file_name)
        if match is None:
            continue
        version: str = f"{match.group(1)}.{match.group(2)}.{match.group(3)}"
        content: str = GeneralUtilities.read_text_from_file(os.path.join(changelog_folder, file_name)).strip()
        # The per-version-file starts with a headline of its own ("# Release notes"), which would become a second
        # top-level-headline inside the combined file. The version is the headline here, so it is removed.
        content = re.sub(r"(?m)\A#[^\n]*\n", "", content).strip()
        # Every headline of the file moves one level down, because it is now below the headline of the version.
        content = re.sub(r"(?m)^#", "##", content)
        versions_with_content[tuple(int(part) for part in version.split("."))] = (version, content)
    if len(versions_with_content) == 0:
        raise ValueError(f"There is no changelog-file in \"{changelog_folder}\", so the published package would not have a changelog.")
    sections: list[str] = list()
    for version_as_numbers in sorted(versions_with_content.keys(), reverse=True):
        version, content = versions_with_content[version_as_numbers]
        sections.append(f"## {version}\n\n{content}\n")
    return "\n".join(sections)


def assert_package_is_publishable(tf: TFCPS_CodeUnitSpecific_Flutter_Functions, package_folder: str) -> None:
    """Verifies with "dart pub publish --dry-run" that the package can be published to pub.dev.

    Doing this in every build means that a mistake which would only show up while publishing (a missing file, a
    dependency which can not be resolved, a pubspec which is not valid) is found by the pipeline instead of by the
    person who wants to release the product.

    "dart pub" determines the files of a package with git when the package lies inside a git-repository. The
    artifacts-folder is git-ignored in the repository of the product, so every file here would count as excluded
    and even the pubspec would be reported as "hidden". Therefore the folder becomes an own git-repository: then
    the only ignore-rules which apply are the ones of the package itself, which are exactly the rules which decide
    what belongs into the published archive."""
    sc = ScriptCollectionCore()
    sc.log.loglevel = tf.get_verbosity()
    sc.run_program("git", "init --quiet .", package_folder)
    sc.run_program(get_path_of_dart_executable(), "pub publish --dry-run", package_folder, print_live_output=True)


def get_path_of_dart_executable() -> str:
    """Returns the absolute path of the "dart"-executable.

    The program is started without a shell, so it has to be given as a path: on windows "dart" is a batch-file
    ("dart.bat") and is therefore not found when it is only named "dart"."""
    path_of_executable: str | None = shutil.which("dart")
    if path_of_executable is None:
        raise ValueError("The program \"dart\" was not found. It is part of the flutter-sdk, which is required to build this codeunit (see the hints in the reference of this codeunit).")
    return path_of_executable


if __name__ == "__main__":
    build()
