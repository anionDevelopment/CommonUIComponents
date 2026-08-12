import { ChangeDetectionStrategy, Component, inject, input } from '@angular/core';
import { MatButtonToggleChange, MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatIconModule } from '@angular/material/icon';
import { NgxDarkmodeService, ThemeMode } from './ngx-darkmode.service';

/**
 * Lets the user choose between the three modes "light", "system" and "dark".
 *
 * All three modes are visible at the same time and every one of them is reachable with one click. A two-state
 * toggle is deliberately not used: it can not express "system", which is the mode most users want, because it
 * follows the setting of their operating-system.
 */
@Component({
  selector: 'ngx-darkmode-toggle-button',
  standalone: true,
  imports: [MatButtonToggleModule, MatIconModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './ngx-darkmode-toggle-button.component.html',
  styleUrl: './ngx-darkmode-toggle-button.component.scss',
})
export class NgxDarkmodeToggleButtonComponent {

  protected readonly service = inject(NgxDarkmodeService);

  /** The label of the whole control. Set it to a translated text if the application is localized. */
  public readonly ariaLabel = input<string>('Color scheme', { alias: 'aria-label' });

  /** The label of the button for the light-mode. */
  public readonly lightLabel = input<string>('Light');

  /** The label of the button which follows the operating-system. */
  public readonly systemLabel = input<string>('System');

  /** The label of the button for the dark-mode. */
  public readonly darkLabel = input<string>('Dark');

  protected onModeChanged(change: MatButtonToggleChange): void {
    this.service.mode.set(change.value as ThemeMode);
  }
}
