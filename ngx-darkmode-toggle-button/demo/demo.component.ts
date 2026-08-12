import { ChangeDetectionStrategy, Component } from '@angular/core';
import { NgxDarkmodeToggleButtonComponent } from '../src/public-api';

/**
 * The application which is used to look at the component and which the visual-regression-tests take their
 * screenshots of. It is not part of the published package.
 */
@Component({
  selector: 'ngx-demo',
  standalone: true,
  imports: [NgxDarkmodeToggleButtonComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './demo.component.html',
  styleUrl: './demo.component.scss',
})
export class DemoComponent { }
