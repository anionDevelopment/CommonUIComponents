import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { DesignPresenterComponent } from './design-presenter.component';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatStepperModule } from '@angular/material/stepper';

describe('DesignPresenterComponent', () => {
  let component: DesignPresenterComponent;
  let fixture: ComponentFixture<DesignPresenterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
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
      declarations: [
        DesignPresenterComponent,
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(DesignPresenterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
