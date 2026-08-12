import { afterNextRender, effect, inject, Injectable, signal, DOCUMENT } from '@angular/core';

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

  /** Whether the stored mode was loaded already. Before that the value of "mode" is only the default. */
  private readonly persistedModeWasRead = signal<boolean>(false);

  public constructor() {
    // The effect is created here and not inside the callback below, because an effect can only be created in an
    // injection-context. Everything it touches is guarded, so it also works with server-side-rendering.
    effect(() => {
      const mode: ThemeMode = this.mode();
      // Nothing is applied and nothing is stored before the stored mode was read. Otherwise the default would
      // overwrite the choice of a returning user in the storage before that choice was even loaded, which would
      // reset the mode to "system" on every reload of the page.
      if (this.persistedModeWasRead()) {
        this.applyMode(mode);
      }
    });
    // Reading the stored mode needs the browser-api, which does not exist while the application is rendered on
    // a server. Therefore it happens after the first render and not in the constructor.
    afterNextRender(() => {
      this.mode.set(this.readPersistedMode());
      this.persistedModeWasRead.set(true);
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
    // With server-side-rendering or prerendering there is no window, so there is neither a storage to write to
    // nor a document whose change would reach the user. The mode is applied again as soon as the page is alive
    // in the browser.
    const window: Window | null = this.document.defaultView;
    if (window === null) {
      return;
    }
    window.localStorage.setItem(themeModeStorageKey, mode);
    if (mode === 'system') {
      this.document.documentElement.removeAttribute('data-theme');
    } else {
      this.document.documentElement.setAttribute('data-theme', mode);
    }
  }
}
