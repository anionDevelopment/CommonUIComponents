import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { OverlayContainer } from '@angular/cdk/overlay';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { NgxCultureSelectorComponent } from './ngx-culture-selector.component';

describe('NgxCultureSelectorComponent', () => {

  let fixture: ComponentFixture<NgxCultureSelectorComponent>;
  let overlayContainer: OverlayContainer;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NgxCultureSelectorComponent, NoopAnimationsModule],
    }).compileComponents();
    fixture = TestBed.createComponent(NgxCultureSelectorComponent);
    fixture.componentRef.setInput('cultures', ['en-GB', 'de', 'de-AT', 'fr']);
    overlayContainer = TestBed.inject(OverlayContainer);
    fixture.detectChanges();
  });

  afterEach(() => {
    overlayContainer.ngOnDestroy();
  });

  it('lists every provided culture as an option', fakeAsync(() => {
    const trigger: HTMLElement = fixture.nativeElement.querySelector('.mat-mdc-select-trigger');
    trigger.click();
    fixture.detectChanges();
    tick();

    const options: NodeListOf<HTMLElement> = overlayContainer.getContainerElement().querySelectorAll('mat-option');
    expect(options.length).toBe(4);
  }));

  it('emits the culture the user chose', fakeAsync(() => {
    const chosenCultures: string[] = [];
    fixture.componentInstance.cultureSelected.subscribe((culture: string) => chosenCultures.push(culture));

    const trigger: HTMLElement = fixture.nativeElement.querySelector('.mat-mdc-select-trigger');
    trigger.click();
    fixture.detectChanges();
    tick();

    const options: NodeListOf<HTMLElement> = overlayContainer.getContainerElement().querySelectorAll('mat-option');
    options[2].click();
    fixture.detectChanges();
    tick();

    expect(chosenCultures).toEqual(['de-AT']);
  }));
});
