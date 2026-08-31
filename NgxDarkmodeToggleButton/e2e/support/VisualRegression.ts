import { expect, Locator, Page, test } from '@playwright/test';
import * as path from 'path';

/*
 * The font which the demo-application uses. A page which is rendered before its font is available looks
 * completely different, so a screenshot which is taken at that moment does not differ from its baseline by a
 * few pixels but by a large part of the image. Checking the font explicitly makes such a case fail with a
 * clear message instead of with a difference which would look like a regression of the user-interface.
 */
const requiredFont: string = '16px Roboto';

interface Box {
    x: number;
    y: number;
    width: number;
    height: number;
}

/*
 * The folder the reference-images for the readme are written to. It has to be inside the codeunit-folder because
 * the visual-regression-tests run in a container which only has that folder mounted; the update-script (see
 * "Other/QualityCheck/UpdateVisualRegressionBaselines.py") copies the images from here into the repository-level
 * "Other/Reference/Technical/Images" afterwards. The folder is part of "Other/Artifacts" and is therefore ignored
 * by git, exactly like the other output of the visual-regression-tests.
 */
const referenceImagesFolder: string = path.join('Other', 'Artifacts', 'ReferenceImages');

/*
 * Returns the bounding box of the given area, or throws if it has none because it is not visible.
 */
async function boundingBoxOf(area: Locator, description: string): Promise<Box> {
    const box: Box | null = await area.boundingBox();
    if (box === null) {
        throw new Error(`Could not determine the bounding box of ${description}: it is not visible.`);
    }
    return box;
}

/*
 * Writes an unconditional, uncompared screenshot of the given area into "referenceImagesFolder", from where the
 * update-script picks it up for the readme. This is deliberately not a visual-regression-test: nothing here is
 * compared with a baseline, the file is simply overwritten with the current appearance.
 *
 * It only happens on chromium and only while the baselines are being regenerated ("--update-snapshots"): the
 * readme-picture is meant to always show one specific, reproducible rendering-engine, and a normal test-run
 * (which also executes on firefox and webkit) must not touch a file which only the update-script owns.
 */
async function saveReferenceImage(page: Page, name: string, area: Box): Promise<void> {
    const testInfo = test.info();
    /*
     * "updateSnapshots" defaults to "missing" (only write a baseline which does not exist yet) when the tests run
     * normally; it is only "all" or "changed" when "--update-snapshots" was passed explicitly, which is exactly
     * the run "task uvrb" performs. Without this check every normal test-run would overwrite the reference-image.
     */
    const baselinesAreBeingUpdated: boolean = testInfo.config.updateSnapshots === 'all' || testInfo.config.updateSnapshots === 'changed';
    if (testInfo.project.name !== 'chromium' || !baselinesAreBeingUpdated) {
        return;
    }
    await page.screenshot({ path: path.join(referenceImagesFolder, `${name}.png`), clip: area });
}

/*
 * Opens the demo-application in the given mode and compares the resulting screenshot with the baseline of the
 * current browser and operating-system. The tolerance of the comparison is defined in playwright.config.ts.
 *
 * The mode is written into the localStorage before the application is loaded, exactly like a returning user
 * would have it: that is the only state this component has, so the testcase does not have to click anything.
 */
export async function expectDemoToLookLikeBaseline(page: Page, mode: string, baselineName: string): Promise<void> {
    /*
     * An error of the application makes it render nothing, and a screenshot of an empty page still is a valid
     * image which is then accepted as the new baseline. Therefore the errors of the page are collected and
     * checked: without this the testcases would silently keep passing while the component is broken.
     */
    const errorsOfPage: string[] = [];
    page.on('pageerror', (error: Error) => errorsOfPage.push(error.message));
    page.on('console', (message) => {
        if (message.type() === 'error') {
            errorsOfPage.push(message.text());
        }
    });

    /*
     * The mode is written into the storage of the loaded page and the page is loaded again afterwards. Writing
     * it before the first navigation does not work: at that moment the browser is still on "about:blank", whose
     * origin has no storage. The second load is exactly the situation of a returning user.
     */
    await page.goto('/');
    await page.evaluate((modeToApply: string) => window.localStorage.setItem('theme', modeToApply), mode);
    await page.reload({ waitUntil: 'networkidle' });
    await page.evaluate(() => document.fonts.ready);
    await page.waitForFunction((font: string) => document.fonts.check(font), requiredFont);

    /* The component has to be there. Without this check an empty page would become the baseline. */
    const component: Locator = page.locator('ngx-darkmode-toggle-button');
    try {
        await expect(component).toBeVisible();
    } catch {
        /* A missing component is only the symptom. What is needed to fix it is what the page itself reported. */
        const bodyOfPage: string = await page.evaluate(() => document.body.innerHTML);
        const reportedErrors: string = 0 < errorsOfPage.length ? errorsOfPage.join(' | ') : '(none)';
        throw new Error(`The component was not rendered. Errors of the page: ${reportedErrors}. Body of the page: ${bodyOfPage}`);
    }
    expect(errorsOfPage, `The page reported errors: ${errorsOfPage.join(' | ')}`).toEqual([]);

    /*
     * The mode has to be applied to the document, otherwise the screenshot would show the appearance of another
     * mode than the one the testcase is about - and a wrong baseline looks exactly like a correct one.
     */
    const stateOfDocument = await page.evaluate(() => ({
        appliedMode: document.documentElement.getAttribute('data-theme'),
        storedMode: window.localStorage.getItem('theme')
    }));
    expect(stateOfDocument).toEqual({ appliedMode: mode === 'system' ? null : mode, storedMode: mode });

    await saveReferenceImage(page, baselineName, await boundingBoxOf(component, 'the theme-switcher'));

    await expect(page).toHaveScreenshot(`${baselineName}.png`, {
        fullPage: true,
        caret: 'hide',
        animations: 'disabled'
    });
}
