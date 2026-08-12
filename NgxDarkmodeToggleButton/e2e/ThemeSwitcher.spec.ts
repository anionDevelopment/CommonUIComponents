import { test } from '@playwright/test';
import { expectDemoToLookLikeBaseline } from './support/VisualRegression';

test.describe('Theme-switcher', () => {

    test('looks like the baseline-screenshot in the mode light', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'light', 'theme-switcher-light');
    });

    test('looks like the baseline-screenshot in the mode dark', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'dark', 'theme-switcher-dark');
    });
});
