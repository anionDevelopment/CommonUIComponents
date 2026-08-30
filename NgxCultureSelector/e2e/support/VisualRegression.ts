import { expect, Page } from '@playwright/test';

/*
 * The font which the demo-application uses. A page which is rendered before its font is available looks
 * completely different, so a screenshot which is taken at that moment does not differ from its baseline by a
 * few pixels but by a large part of the image. Checking the font explicitly makes such a case fail with a
 * clear message instead of with a difference which would look like a regression of the user-interface.
 */
const requiredFont: string = '16px Roboto';

/*
 * Opens the demo-application, optionally opens the dropdown of the culture-selector, and compares the
 * resulting screenshot with the baseline of the current browser and operating-system. The tolerance of the
 * comparison is defined in playwright.config.ts.
 *
 * Unlike the theme-switcher of ngx-darkmode-toggle-button this component has no persisted state to write
 * before the page is loaded: its only state ("is the dropdown open") is purely interactive, so it is reached
 * by clicking the control after the page has loaded.
 */
export async function expectDemoToLookLikeBaseline(page: Page, openDropdown: boolean, baselineName: string): Promise<void> {
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

    await page.goto('/');
    await page.evaluate(() => document.fonts.ready);
    await page.waitForFunction((font: string) => document.fonts.check(font), requiredFont);

    /* The component has to be there. Without this check an empty page would become the baseline. */
    try {
        await expect(page.locator('ngx-culture-selector')).toBeVisible();
    } catch {
        /* A missing component is only the symptom. What is needed to fix it is what the page itself reported. */
        const bodyOfPage: string = await page.evaluate(() => document.body.innerHTML);
        const reportedErrors: string = 0 < errorsOfPage.length ? errorsOfPage.join(' | ') : '(none)';
        throw new Error(`The component was not rendered. Errors of the page: ${reportedErrors}. Body of the page: ${bodyOfPage}`);
    }

    if (openDropdown) {
        /*
         * The accessible role, not an internal css-class, is used to find and open the control: `mat-select`
         * renders itself as a "combobox" and its options as "option", which is stable across Material-versions.
         */
        await page.getByRole('combobox').click();
        /* The dropdown is rendered into an overlay which is attached asynchronously; wait for its first option. */
        await expect(page.getByRole('option').first()).toBeVisible();
    }

    expect(errorsOfPage, `The page reported errors: ${errorsOfPage.join(' | ')}`).toEqual([]);

    await expect(page).toHaveScreenshot(`${baselineName}.png`, {
        fullPage: true,
        caret: 'hide',
        animations: 'disabled'
    });
}
