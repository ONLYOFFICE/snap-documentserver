import { test } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('/example/');
  const page1Promise = page.waitForEvent('popup');

  await page.getByRole('link', { name: 'Document', exact: true }).click();
  const page1 = await page1Promise;
  await page.waitForTimeout(5000);
  await page1.locator('iframe[name="frameEditor"]').contentFrame().locator('#area_id').fill('OnlyOffice');
  const page2Promise = page.waitForEvent('popup');
  await page.waitForTimeout(5000);

  await page.getByRole('link', { name: 'Spreadsheet' }).click();
  const page2 = await page2Promise;
  await page.waitForTimeout(5000);
  await page2.locator('iframe[name="frameEditor"]').contentFrame().locator('#area_id').fill('OnlyOffice ');
  const page3Promise = page.waitForEvent('popup');
  await page.waitForTimeout(5000);

  await page.getByRole('link', { name: 'Presentation' }).click();
  const page3 = await page3Promise;
  await page.waitForTimeout(5000);
  await page3.locator('iframe[name="frameEditor"]').contentFrame().locator('#area_id').fill('OnlyOffice');
  const page4Promise = page.waitForEvent('popup');
  await page.waitForTimeout(5000);

  await page.getByRole('link', { name: 'PDF form' }).click();
  const page4 = await page4Promise;
  await page.waitForTimeout(5000);
  await page4.locator('iframe[name="frameEditor"]').contentFrame().locator('#area_id').fill('OnlyOffice');
  await page.waitForTimeout(5000);
});
