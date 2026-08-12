import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NgxDarkmodeToggleButtonComponent } from './ngx-darkmode-toggle-button.component';

describe('NgxDarkmodeToggleButtonComponent', () => {
  let component: NgxDarkmodeToggleButtonComponent;
  let fixture: ComponentFixture<NgxDarkmodeToggleButtonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [NgxDarkmodeToggleButtonComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(NgxDarkmodeToggleButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
