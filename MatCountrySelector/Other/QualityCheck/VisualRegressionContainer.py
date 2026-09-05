"""Runs the visual-regression-tests of MatCountrySelector (test/visual_regression) inside a container.

Unlike the visual-regression-tests of a web-frontend (see TFCPS_VisualRegressionTests / the
"automation-using-scriptcollection"-skill), Flutter has no per-codeunit-type support for this in ScriptCollection
yet, so this module implements the (small) part it is missing: running "flutter test" against the fixed "SCBuilder"
image (see ".ScriptCollection/OCIImages/ImageDefinition.csv"), so that the images the tests render - and therefore
the baseline-images they are compared with - are reproducible independently of the operating-system of the
developer or of the build-agent. See the docstring of "test/visual_regression/visual_regression.dart" for why this
is required at all.

This only covers running "flutter test" directly on the host (Windows or Linux) that starts the container: it does
not (yet) support being started from inside an already-containerized "scbuildcodeunits -c"-run, which would need the
same nested-container-handling ("--volumes-from" instead of a bind-mount) that TFCPS_VisualRegressionTests
implements for Playwright. Add that the same way if/when this has to run from inside such a build.
"""
from ScriptCollection.ScriptCollectionCore import ScriptCollectionCore
from ScriptCollection.TFCPS.Flutter.TFCPS_CodeUnitSpecific_Flutter import TFCPS_CodeUnitSpecific_Flutter_Functions

# The image is defined as "SCBuilder" in ".ScriptCollection/OCIImages/ImageDefinition.csv" of the repository; it is
# the same image the rest of the pipeline is built with (see the "work-with-common-project-structure"-skill), which
# already contains the Flutter-SDK.
_image_name: str = "SCBuilder"

_package_name: str = "mat_country_selector"

# Relative to the dart-package ("mat_country_selector"). Only this folder is passed to "flutter test", so that the
# normal (non-visual) testcases are never re-run here.
_visual_regression_tests_relative_path: str = "test/visual_regression"

_codeunit_folder_in_container: str = "/codeunit"


def run_visual_regression_tests(tf: TFCPS_CodeUnitSpecific_Flutter_Functions, update_baselines: bool) -> None:
    """Runs the visual-regression-tests of the codeunit inside the container.
    If 'update_baselines' is true then the baseline-images are (re-)generated instead of being compared."""
    sc = ScriptCollectionCore()
    sc.log.loglevel = tf.get_verbosity()
    codeunit_folder: str = tf.get_codeunit_folder()
    repository_folder: str = tf.get_repository_folder()
    image: str = tf.tfcps_Tools_General.oci_image_manager.get_registry_address_for_image_with_default_tag(repository_folder, _image_name)
    image_address, image_tag = ScriptCollectionCore.split_image_address_and_tag(image)
    _assert_docker_daemon_is_reachable(sc)
    sc.docker_pull(image_address, image_tag)

    package_folder_in_container: str = f"{_codeunit_folder_in_container}/{_package_name}"
    # The ".dart_tool"-folders are hidden behind own volumes, so that "flutter pub get" (which has to run inside the
    # container, because a ".dart_tool"-folder which was generated on the host contains host-specific/absolute
    # paths) neither uses nor overwrites the ones of the host. The volumes are reused by the following runs, so only
    # the first run has to download the packages again. The example-application gets one of its own because
    # "flutter pub get" of the package resolves it as well.
    dart_tool_volume_name: str = f"{tf.get_codeunit_name().lower()}-visual-regression-tests-dart-tool"
    example_dart_tool_volume_name: str = f"{dart_tool_volume_name}-example"
    command: str = "flutter pub get && flutter test"
    if update_baselines:
        command = f"{command} --update-goldens"
    command = f"{command} --tags visual-regression --run-skipped {_visual_regression_tests_relative_path}"
    arguments: list[str] = [
        "run", "--rm",
        "-v", f"{codeunit_folder}:{_codeunit_folder_in_container}",
        "-v", f"{dart_tool_volume_name}:{package_folder_in_container}/.dart_tool",
        "-v", f"{example_dart_tool_volume_name}:{package_folder_in_container}/example/.dart_tool",
        "-w", package_folder_in_container,
        image, "/bin/sh", "-c", command,
    ]
    result = sc.run_program_argsasarray("docker", arguments, throw_exception_if_exitcode_is_not_zero=False, print_live_output=True, print_errors_as_information=True)
    if result[0] != 0:
        verb: str = "updating the baseline-images of" if update_baselines else "running"
        raise ValueError(f"The visual-regression-tests of MatCountrySelector failed while {verb} them (docker exit-code {result[0]}).")


def _assert_docker_daemon_is_reachable(sc: ScriptCollectionCore) -> None:
    # Without this check an unreachable daemon would look like a failed testcase, because "docker run" returns a
    # non-zero exit-code in both cases.
    result = sc.run_program_argsasarray("docker", ["version", "--format", "{{.Server.Version}}"], throw_exception_if_exitcode_is_not_zero=False, print_live_output=False)
    if result[0] != 0:
        raise ValueError(f"The visual-regression-tests can not be executed because the docker-daemon is not reachable (exit-code {result[0]}: {result[2].strip()}). They are executed via \"docker run\", which requires a running docker-daemon.")
