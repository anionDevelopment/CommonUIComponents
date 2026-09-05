import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectChange, MatSelectModule } from '@angular/material/select';
import { allCountries } from './all-countries';
import { NgxCountry, labelOf } from './ngx-country';

/**
 * Lets the user choose one country, shown with its flag and its english name.
 *
 * Unlike a selector which is handed its entries, this component brings the countries with it: `allCountries`, the
 * list of ISO 3166-1. An application which wants "a country-selector" therefore binds nothing but the output, and
 * one which offers only some countries passes its own `countries`. What the chosen country *means* - a
 * nationality, a place of residence, a shipping-destination - is the application's business; the component emits
 * the code of the country and does nothing else with it.
 *
 * A country is found by typing its name: `mat-select` jumps to the option whose text starts with the letters
 * which are typed while the list is open, which is what keeps a list of almost 250 entries usable without a
 * search-field of its own.
 */
@Component({
  selector: 'ngx-country-selector',
  standalone: true,
  imports: [MatFormFieldModule, MatSelectModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './ngx-country-selector.component.html',
  styleUrl: './ngx-country-selector.component.scss',
})
export class NgxCountrySelectorComponent {

  /** The countries the user can choose from, in the order they are offered. Defaults to every country there is. */
  public readonly countries = input<readonly NgxCountry[]>(allCountries);

  /** The code of the country which is preselected. */
  public readonly selectedCountry = input<string | undefined>(undefined);

  /** The label of the control itself. Set it to a translated text if the application is localized. */
  public readonly label = input<string>('Country');

  /** Emits the code of the country the user chose, for example "DE". */
  public readonly countrySelected = output<string>();

  /** What is shown for one country: its flag and its english name. */
  protected labelOf(country: NgxCountry): string {
    return labelOf(country);
  }

  protected onSelectionChange(change: MatSelectChange): void {
    this.countrySelected.emit(change.value as string);
  }
}
