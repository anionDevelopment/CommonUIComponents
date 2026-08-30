import { ComponentFixture, TestBed } from '@angular/core/testing';
import { HarnessLoader } from '@angular/cdk/testing';
import { TestbedHarnessEnvironment } from '@angular/cdk/testing/testbed';
import { MatSelectHarness } from '@angular/material/select/testing';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { NgxCultureOption, NgxCultureSelectorComponent } from './ngx-culture-selector.component';

describe('NgxCultureSelectorComponent', () => {

  const cultures: NgxCultureOption[] = [
    { culture: 'en-GB', label: 'English (UK)' },
    { culture: 'de', label: 'German' },
    { culture: 'de-AT', label: 'German (Austria)' },
    { culture: 'fr', label: 'French' },
  ];

  let fixture: ComponentFixture<NgxCultureSelectorComponent>;
  let loader: HarnessLoader;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NgxCultureSelectorComponent, NoopAnimationsModule],
    }).compileComponents();
    fixture = TestBed.createComponent(NgxCultureSelectorComponent);
    fixture.componentRef.setInput('cultures', cultures);
    fixture.detectChanges();
    loader = TestbedHarnessEnvironment.loader(fixture);
  });

  it('lists the label of every provided culture as an option', async () => {
    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    await select.open();

    const options = await select.getOptions();
    const labels: string[] = await Promise.all(options.map((option) => option.getText()));
    expect(labels).toEqual(cultures.map((culture) => culture.label));
  });

  it('shows the label of the preselected culture in the trigger', async () => {
    fixture.componentRef.setInput('selectedCulture', 'de-AT');
    fixture.detectChanges();

    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    expect(await select.getValueText()).toBe('German (Austria)');
  });

  it('emits the culture-identifier of the culture the user chose', async () => {
    const chosenCultures: string[] = [];
    fixture.componentInstance.cultureSelected.subscribe((culture: string) => chosenCultures.push(culture));

    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    await select.clickOptions({ text: 'German (Austria)' });

    expect(chosenCultures).toEqual(['de-AT']);
  });
});
