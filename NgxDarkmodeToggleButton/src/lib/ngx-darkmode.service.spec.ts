import { TestBed } from '@angular/core/testing';
import { NgxDarkmodeService, themeModes } from './ngx-darkmode.service';

describe('NgxDarkmodeService', () => {

  let service: NgxDarkmodeService;

  beforeEach(() => {
    localStorage.clear();
    TestBed.configureTestingModule({});
    service = TestBed.inject(NgxDarkmodeService);
  });

  it('uses the mode "system" as long as the user did not choose another one', () => {
    expect(service.mode()).toBe('system');
  });

  it('accepts every supported mode', () => {
    for (const mode of themeModes) {
      service.mode.set(mode);
      expect(service.mode()).toBe(mode);
    }
  });

  it('declares exactly the three modes of the specification', () => {
    expect(themeModes).toEqual(['system', 'light', 'dark']);
  });
});
