import { test } from '@playwright/test';
import { expectDemoToLookLikeBaseline } from './support/VisualRegression';

test.describe('Country-selector', () => {

    test('looks like the baseline-screenshot when closed in the light color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'light', false, 'country-selector-closed-light');
    });

    test('looks like the baseline-screenshot when closed in the dark color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'dark', false, 'country-selector-closed-dark');
    });

    test('looks like the baseline-screenshot when opened in the light color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'light', true, 'country-selector-open-light');
    });

    test('looks like the baseline-screenshot when opened in the dark color-scheme', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, 'dark', true, 'country-selector-open-dark');
    });
});
