import { DOCUMENT } from '@angular/common';
import { afterNextRender, Injectable, effect, inject, signal } from '@angular/core';

/** The setting the user chose. It is not the scheme which is displayed: in the mode "system" that is decided by the operating-system. */
export type ThemeMode = 'system' | 'light' | 'dark';

/** The key under which the chosen mode is stored, so that it survives a reload of the page and a new session. */
export const themeModeStorageKey = 'theme';

/** All values which are accepted as mode. Everything else is treated as "system". */
export const themeModes: readonly ThemeMode[] = ['system', 'light', 'dark'];

/**
 * Holds the mode the user chose and applies it to the document.
 *
 * The mode is applied by the attribute "data-theme" on the html-element and nothing else. The stylesheet of the
 * application maps that attribute to the css-property "color-scheme" (see the ReadMe), so neither a second theme
 * nor an exchange of stylesheets at runtime is required. The mode "system" removes the attribute, which lets the
 * value "light dark" of the stylesheet decide and therefore follows the operating-system - including a change of
 * the system-preference while the application is running, because "color-scheme" reacts to it by itself.
 */
@Injectable({ providedIn: 'root' })
export class NgxDarkmodeService {

  private readonly document = inject(DOCUMENT);

  /** The mode the user chose. Write to it to change the mode. */
  public readonly mode = signal<ThemeMode>('system');

  public constructor() {
    // The browser-api is only available after the first render: with server-side-rendering or prerendering there
    // is neither a localStorage nor a window while the component is constructed.
    afterNextRender(() => {
      this.mode.set(this.readPersistedMode());
      effect(() => this.applyMode(this.mode()));
    });
  }

  /** Returns the stored mode. A missing or an invalid value is treated as "system". */
  private readPersistedMode(): ThemeMode {
    const persistedValue: string | null = this.document.defaultView?.localStorage?.getItem(themeModeStorageKey) ?? null;
    return this.isThemeMode(persistedValue) ? persistedValue : 'system';
  }

  private isThemeMode(value: string | null): value is ThemeMode {
    return value !== null && themeModes.includes(value as ThemeMode);
  }

  private applyMode(mode: ThemeMode): void {
    this.document.defaultView?.localStorage?.setItem(themeModeStorageKey, mode);
    if (mode === 'system') {
      this.document.documentElement.removeAttribute('data-theme');
    } else {
      this.document.documentElement.setAttribute('data-theme', mode);
    }
  }
}
