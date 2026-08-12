import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatIconModule } from '@angular/material/icon';
import { DesignPresenterComponent } from './design-presenter/design-presenter.component';
import { NgxDarkmodeService } from './ngx-darkmode/ngx-darkmode.service';
import { NgxDarkmodeToggleButtonComponent } from './ngx-darkmode-toggle-button/ngx-darkmode-toggle-button.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatStepperModule } from '@angular/material/stepper';

@NgModule({
  declarations: [
    NgxDarkmodeToggleButtonComponent,
    DesignPresenterComponent,
  ],
  imports: [
    BrowserAnimationsModule,
    FormsModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatSelectModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    MatToolbarModule,
    MatSidenavModule,
    MatListModule,
    MatStepperModule,
  ],
  providers: [
    NgxDarkmodeService,
  ],
  bootstrap: [
    NgxDarkmodeToggleButtonComponent,
  ],
})
export class NgxDarkmodeToggleButtonModule { }
