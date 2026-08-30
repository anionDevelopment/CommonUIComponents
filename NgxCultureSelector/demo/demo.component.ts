import { ChangeDetectionStrategy, Component } from '@angular/core';
import { NgxCultureSelectorComponent } from '../src/public-api';

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

  protected readonly cultures: string[] = ['en-GB', 'de', 'de-AT', 'fr'];

  protected chosenCulture: string | undefined;

  protected onCultureSelected(culture: string): void {
    this.chosenCulture = culture;
  }
}
