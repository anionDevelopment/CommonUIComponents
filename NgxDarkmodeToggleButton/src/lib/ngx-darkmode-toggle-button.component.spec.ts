import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { NgxDarkmodeToggleButtonComponent } from './ngx-darkmode-toggle-button.component';
import { NgxDarkmodeService } from './ngx-darkmode.service';

describe('NgxDarkmodeToggleButtonComponent', () => {

  let fixture: ComponentFixture<NgxDarkmodeToggleButtonComponent>;
  let service: NgxDarkmodeService;

  beforeEach(async () => {
    localStorage.clear();
    await TestBed.configureTestingModule({
      imports: [NgxDarkmodeToggleButtonComponent, NoopAnimationsModule],
    }).compileComponents();
    fixture = TestBed.createComponent(NgxDarkmodeToggleButtonComponent);
    service = TestBed.inject(NgxDarkmodeService);
    fixture.detectChanges();
  });

  it('offers all three modes at the same time', () => {
    const buttons: NodeListOf<HTMLElement> = fixture.nativeElement.querySelectorAll('mat-button-toggle');
    expect(buttons.length).toBe(3);
  });

  it('marks the mode which is currently chosen', () => {
    service.mode.set('dark');
    fixture.detectChanges();
    const checkedButton: HTMLElement | null = fixture.nativeElement.querySelector('mat-button-toggle.mat-button-toggle-checked');
    expect(checkedButton?.textContent?.trim()).toBe('dark_mode');
  });

  it('changes the mode when the user chooses another one', () => {
    const darkButton: HTMLElement = fixture.nativeElement.querySelectorAll('mat-button-toggle button')[2];
    darkButton.click();
    fixture.detectChanges();
    expect(service.mode()).toBe('dark');
  });
});
