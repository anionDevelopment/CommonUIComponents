import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectChange, MatSelectModule } from '@angular/material/select';

/**
 * One culture the user can choose, together with the text which is shown for it.
 */
export interface NgxCultureOption {

  /** The culture-identifier, for example "en-GB", "de" or "de-AT". This is the value which `cultureSelected` emits. */
  culture: string;

  /** The text shown for this entry, typically the name of the language in English, for example "English (UK)". */
  label: string;
}

/**
 * Lets the user choose one culture from a list of cultures.
 *
 * The trigger always shows the label of the currently chosen culture; clicking it opens a dropdown which lists
 * the labels of every culture that was passed in - this is the native behavior of `mat-select` and needs no
 * further code. The component does not know anything about cultures itself: both the list of offered cultures
 * and the text shown for each of them are passed in by the caller, and the chosen entry's `culture` is reported
 * as-is through `cultureSelected`. Applying the choice (for example switching the locale of the application) is
 * deliberately left to the application which uses the component.
 */
@Component({
  selector: 'ngx-culture-selector',
  standalone: true,
  imports: [MatFormFieldModule, MatSelectModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './ngx-culture-selector.component.html',
  styleUrl: './ngx-culture-selector.component.scss',
})
export class NgxCultureSelectorComponent {

  /** The cultures the user can choose from, each with its culture-identifier and the text shown for it. */
  public readonly cultures = input.required<NgxCultureOption[]>();

  /** The culture-identifier which is preselected. */
  public readonly selectedCulture = input<string | undefined>(undefined);

  /** The label of the control itself. Set it to a translated text if the application is localized. */
  public readonly label = input<string>('Culture');

  /** Emits the culture-identifier of the culture the user chose. */
  public readonly cultureSelected = output<string>();

  protected onSelectionChange(change: MatSelectChange): void {
    this.cultureSelected.emit(change.value as string);
  }
}
