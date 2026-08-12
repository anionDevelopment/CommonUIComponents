import { expect, Page } from '@playwright/test';

/*
 * The font which the demo-application uses. A page which is rendered before its font is available looks
 * completely different, so a screenshot which is taken at that moment does not differ from its baseline by a
 * few pixels but by a large part of the image. Checking the font explicitly makes such a case fail with a
 * clear message instead of with a difference which would look like a regression of the user-interface.
 */
const requiredFont: string = '16px Roboto';

/*
 * Opens the demo-application in the given mode and compares the resulting screenshot with the baseline of the
 * current browser and operating-system. The tolerance of the comparison is defined in playwright.config.ts.
 *
 * The mode is written into the localStorage before the application is loaded, exactly like a returning user
 * would have it: that is the only state this component has, so the testcase does not have to click anything.
 */
export async function expectDemoToLookLikeBaseline(page: Page, mode: string, baselineName: string): Promise<void> {
    await page.addInitScript((modeToApply: string) => window.localStorage.setItem('theme', modeToApply), mode);
    await page.goto('/', { waitUntil: 'networkidle' });
    await page.evaluate(() => document.fonts.ready);
    await page.waitForFunction((font: string) => document.fonts.check(font), requiredFont);
    await expect(page).toHaveScreenshot(`${baselineName}.png`, {
        fullPage: true,
        caret: 'hide',
        animations: 'disabled'
    });
}
