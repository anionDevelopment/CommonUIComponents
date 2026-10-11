import { test } from '@playwright/test';
import { expectDemoToLookLikeBaseline } from './support/VisualRegression';

test.describe('Culture-selector', () => {

    test('looks like the baseline-screenshot when closed in the light color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'light', false, 'culture-selector-closed-light');
    });

    test('looks like the baseline-screenshot when closed in the dark color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'dark', false, 'culture-selector-closed-dark');
    });

    test('looks like the baseline-screenshot when opened in the light color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'light', true, 'culture-selector-open-light');
    });

    test('looks like the baseline-screenshot when opened in the dark color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'dark', true, 'culture-selector-open-dark');
    });
});
