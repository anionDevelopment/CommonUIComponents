import { test } from '@playwright/test';
import { expectDemoToLookLikeBaseline } from './support/VisualRegression';

test.describe('Culture-selector', () => {

    test('looks like the baseline-screenshot when closed', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, false, 'culture-selector-closed');
    });

    test('looks like the baseline-screenshot when opened', async ({ page }) => {
        await expectDemoToLookLikeBaseline(page, true, 'culture-selector-open');
    });
});
