import { provideZoneChangeDetection } from "@angular/core";
import { provideAnimations } from '@angular/platform-browser/animations';
import { bootstrapApplication } from '@angular/platform-browser';
import { DemoComponent } from './demo.component';

bootstrapApplication(DemoComponent, {
  providers: [provideZoneChangeDetection(),provideAnimations()]
}).catch((error: unknown) => console.error(error));
