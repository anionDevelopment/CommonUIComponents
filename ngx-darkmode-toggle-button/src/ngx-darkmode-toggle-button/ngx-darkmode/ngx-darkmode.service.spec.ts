import { TestBed } from '@angular/core/testing';

import { NgxDarkmodeService } from './ngx-darkmode.service';

describe('NgxDarkmodeService', () => {
  let service: NgxDarkmodeService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(NgxDarkmodeService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
