import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { DesignMode, NgxDarkmodeService } from '../ngx-darkmode/ngx-darkmode.service';

@Component({
  selector: 'ngx-darkmode-toggle-button',
  templateUrl: `./ngx-darkmode-toggle-button.component.html`,
  styleUrls: [`./ngx-darkmode-toggle-button.component.css`]
})
export class NgxDarkmodeToggleButtonComponent implements OnInit, OnDestroy {

  designs: DesignMode[];
  currentDesign: FormControl;
  formGroup: FormGroup;
  compareFn(f1: DesignMode, f2: DesignMode): boolean {
    return f1 && f2 ? f1.value === f2.value : f1 === f2;
  }
  destroy$: Subject<void> = new Subject<void>();

  constructor(public ngxDarkmodeService: NgxDarkmodeService) {

    this.designs = [
      { value: this.ngxDarkmodeService.systemModeName, icon: 'settings_suggest', viewValue: 'Follow system-design' },
      { value: this.ngxDarkmodeService.lightModeName, icon: 'light_mode', viewValue: 'Light-mode' },
      { value: this.ngxDarkmodeService.darkModeName, icon: 'dark_mode', viewValue: 'Dark-mode' }
    ];
  }

  ngOnInit(): void {
    this.currentDesign = new FormControl();
    this.formGroup = new FormGroup([this.currentDesign]);
    this.currentDesign.valueChanges.pipe(takeUntil(this.destroy$)).subscribe((newDesign: DesignMode) => {
      this.ngxDarkmodeService.setMode(newDesign);
    });
    this.currentDesign.setValue(this.designs[0]);
    this.updateUI(this.ngxDarkmodeService.getCurrentSystemMode());
    this.ngxDarkmodeService.modeChanged.pipe(takeUntil(this.destroy$)).subscribe(newMode => this.updateUI(newMode));
  }

  ngOnDestroy(): void {
    this.destroy$.next();
  }

  updateUI(newMode: DesignMode): void {
    if (newMode.value === this.ngxDarkmodeService.lightModeName) {
      //TODO update the icon and the font-/background-color of the component to lightmode
    } else if (newMode.value === this.ngxDarkmodeService.darkModeName) {
      //TODO update the icon and the font-/background-color of the component to darkmode
    } else {
      //TODO raise error
    }
  }

}
