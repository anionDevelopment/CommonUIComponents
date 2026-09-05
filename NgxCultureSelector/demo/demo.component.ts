import { ChangeDetectionStrategy, Component } from '@angular/core';
import { NgxCultureOption, NgxCultureSelectorComponent } from '../src/public-api';

/**
 * The application which is used to look at the component. It is not part of the published package.
 */
@Component({
  selector: 'ngx-demo',
  standalone: true,
  imports: [NgxCultureSelectorComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './demo.component.html',
  styleUrl: './demo.component.scss',
})
export class DemoComponent {

  protected readonly cultures: NgxCultureOption[] = [
    { culture: 'en-GB', label: 'English (UK)' },
    { culture: 'de', label: 'German' },
    { culture: 'de-AT', label: 'German (Austria)' },
    { culture: 'fr', label: 'French' },
  ];

  protected chosenCulture: string | undefined;

  protected onCultureSelected(culture: string): void {
    this.chosenCulture = culture;
  }
}
