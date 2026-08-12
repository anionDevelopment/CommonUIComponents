import { EventEmitter, Injectable, OnInit, Output } from '@angular/core';

export interface DesignMode {
  value: string;
  viewValue: string;
  icon: any;
}
@Injectable({
  providedIn: 'root'
})
export class NgxDarkmodeService implements OnInit {

  lightModeName: string = "light";
  darkModeName: string = "dark";
  systemModeName: string = "system";
  private currentMode: DesignMode;

  /** Emits 2 possible output-values: this.lightModeName and this.darkModeName. */
  @Output()
  modeChanged = new EventEmitter<DesignMode>();

  designs: DesignMode[] = [
    { value: this.systemModeName, icon: 'settings_suggest', viewValue: 'Follow system-design' },
    { value: this.lightModeName, icon: 'light_mode', viewValue: 'Light-mode' },
    { value: this.darkModeName, icon: 'dark_mode', viewValue: 'Dark-mode' }
  ];
  constructor() {
    this.currentMode = this.getCurrentSystemMode();
  }

  getSystemMode(): DesignMode {
    return this.designs[0];
  }

  getLightMode(): DesignMode {
    return this.designs[1];
  }

  getDarkMode(): DesignMode {
    return this.designs[2];
  }

  ngOnInit(): void {
    //listen on external changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
      this.setMode(e.matches ? this.getDarkMode() : this.getLightMode());
    });
  }

  getCurrentSystemMode(): DesignMode {
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)') ? this.getDarkMode() : this.getLightMode();
  }

  getCurrentMode(): string {
    return this.lightModeName;
  }

  /** Accepts 3 possible input-values: this.lightModeName, this.darkModeName and this.systemModeName. */
  setMode(modeName: DesignMode): void {
    if (!(modeName.value === this.lightModeName || modeName.value === this.darkModeName || modeName.value === this.systemModeName)) {
      //TODO raise exception
    }
    if (modeName.value === this.systemModeName) {
      modeName = this.getCurrentSystemMode();
    }
    if (this.currentMode !== modeName) {
      this.currentMode = modeName;
      this.modeChanged.next(this.currentMode);
    }
  }
}
