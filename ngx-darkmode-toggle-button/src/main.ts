import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { NgxDarkmodeToggleButtonModule } from './ngx-darkmode-toggle-button/ngx-darkmode-toggle-button.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(NgxDarkmodeToggleButtonModule)
  .catch(err => console.error(err));
