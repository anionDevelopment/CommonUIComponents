import { test } from '@playwright/test';
import { expectDemoToLookLikeBaseline } from './support/VisualRegression';

test.describe('Country-selector', () => {

    test('looks like the baseline-screenshot when closed', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, false, 'country-selector-closed');
    });

    test('looks like the baseline-screenshot when opened', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, true, 'country-selector-open');
    });
});
