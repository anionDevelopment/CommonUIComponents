import { ChangeDetectionStrategy, Component } from '@angular/core';
import { NgxCountrySelectorComponent } from '../src/public-api';

/**
 * The application which is used to look at the component. It is not part of the published package.
 */
@Component({
  selector: 'ngx-demo',
  standalone: true,
  imports: [NgxCountrySelectorComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './demo.component.html',
  styleUrl: './demo.component.scss',
})
export class DemoComponent {

  protected chosenCountry: string | undefined;

  protected onCountrySelected(country: string): void {
    this.chosenCountry = country;
  }
}
