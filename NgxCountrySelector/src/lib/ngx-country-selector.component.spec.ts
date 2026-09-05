import { ComponentFixture, TestBed } from '@angular/core/testing';
import { HarnessLoader } from '@angular/cdk/testing';
import { TestbedHarnessEnvironment } from '@angular/cdk/testing/testbed';
import { MatSelectHarness } from '@angular/material/select/testing';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { allCountries } from './all-countries';
import { NgxCountry, flagOf, labelOf } from './ngx-country';
import { NgxCountrySelectorComponent } from './ngx-country-selector.component';

describe('flagOf', () => {

  it('derives the flag of a country from its code', () => {
    // Two regional-indicator-letters: "D" and "E" for germany.
    expect(flagOf('DE')).toBe('\u{1f1e9}\u{1f1ea}');
    expect(flagOf('JP')).toBe('\u{1f1ef}\u{1f1f5}');
  });

  it('derives the flag from a lower-case code as well', () => {
    expect(flagOf('de')).toBe(flagOf('DE'));
  });

  it('has no flag for something which is not a two-letter-code', () => {
    expect(flagOf('GER')).toBe('');
  });

  it('shows a country as its flag and its english name', () => {
    expect(labelOf({ code: 'DE', name: 'Germany' })).toBe('\u{1f1e9}\u{1f1ea} Germany');
  });
});

describe('allCountries', () => {

  it('holds the countries of ISO 3166-1', () => {
    expect(allCountries.length).toBe(249);
    expect(allCountries).toContain({ code: 'DE', name: 'Germany' });
  });

  it('gives every country its own code', () => {
    const codes: Set<string> = new Set(allCountries.map((country) => country.code));

    expect(codes.size).toBe(allCountries.length);
  });

  it('states every code as two upper-case letters', () => {
    for (const country of allCountries) {
      expect(country.code).toMatch(/^[A-Z]{2}$/);
    }
  });

  it('is ordered by the english name, which is how it is read', () => {
    const names: string[] = allCountries.map((country) => country.name);

    expect(names).toEqual([...names].sort());
  });
});

describe('NgxCountrySelectorComponent', () => {

  const countries: NgxCountry[] = [
    { code: 'DE', name: 'Germany' },
    { code: 'FR', name: 'France' },
    { code: 'JP', name: 'Japan' },
  ];

  let fixture: ComponentFixture<NgxCountrySelectorComponent>;
  let loader: HarnessLoader;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NgxCountrySelectorComponent, NoopAnimationsModule],
    }).compileComponents();
    fixture = TestBed.createComponent(NgxCountrySelectorComponent);
    fixture.componentRef.setInput('countries', countries);
    fixture.detectChanges();
    loader = TestbedHarnessEnvironment.loader(fixture);
  });

  it('lists every provided country with its flag and its name', async () => {
    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    await select.open();

    const options = await select.getOptions();
    const labels: string[] = await Promise.all(options.map((option) => option.getText()));
    expect(labels).toEqual(countries.map((country) => labelOf(country)));
  });

  it('offers all countries of the world when it was given none', async () => {
    const withoutAList: ComponentFixture<NgxCountrySelectorComponent> =
      TestBed.createComponent(NgxCountrySelectorComponent);
    withoutAList.detectChanges();
    const select: MatSelectHarness = await TestbedHarnessEnvironment.loader(withoutAList).getHarness(MatSelectHarness);
    await select.open();

    expect((await select.getOptions()).length).toBe(allCountries.length);
  });

  it('shows the preselected country in the trigger', async () => {
    fixture.componentRef.setInput('selectedCountry', 'JP');
    fixture.detectChanges();

    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    expect(await select.getValueText()).toBe(labelOf({ code: 'JP', name: 'Japan' }));
  });

  it('shows the label it was given', async () => {
    fixture.componentRef.setInput('label', 'Nationality');
    fixture.detectChanges();

    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    expect(await select.getValueText()).toBeDefined();
    expect(fixture.nativeElement.textContent as string).toContain('Nationality');
  });

  it('emits the code of the country the user chose, not its name', async () => {
    const chosenCountries: string[] = [];
    fixture.componentInstance.countrySelected.subscribe((country: string) => chosenCountries.push(country));

    const select: MatSelectHarness = await loader.getHarness(MatSelectHarness);
    await select.clickOptions({ text: labelOf({ code: 'FR', name: 'France' }) });

    expect(chosenCountries).toEqual(['FR']);
  });
});
