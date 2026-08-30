import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectChange, MatSelectModule } from '@angular/material/select';

/**
 * Lets the user choose one culture (for example "en-GB", "de", "de-AT" or "fr") from a list of cultures.
 *
 * The component does not know anything about cultures itself: the list is passed in by the caller and the
 * chosen entry is reported as-is through `cultureSelected`. Applying the choice (for example switching the
 * locale of the application) is deliberately left to the application which uses the component.
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

  /** The cultures the user can choose from, for example `['en-GB', 'de', 'de-AT', 'fr']`. */
  public readonly cultures = input.required<string[]>();

  /** The culture which is preselected. */
  public readonly selectedCulture = input<string | undefined>(undefined);

  /** The label of the control. Set it to a translated text if the application is localized. */
  public readonly label = input<string>('Culture');

  /** Emits the culture the user chose. */
  public readonly cultureSelected = output<string>();

  protected onSelectionChange(change: MatSelectChange): void {
    this.cultureSelected.emit(change.value as string);
  }
}
