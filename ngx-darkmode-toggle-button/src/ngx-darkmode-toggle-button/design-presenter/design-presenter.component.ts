import { Component, Input, OnInit } from '@angular/core';
import { DesignMode } from '../ngx-darkmode/ngx-darkmode.service';

@Component({
  selector: 'app-design-presenter',
  templateUrl: './design-presenter.component.html',
  styleUrls: ['./design-presenter.component.scss']
})
export class DesignPresenterComponent implements OnInit {

  @Input()
  design: DesignMode = { value: 'systemModeName', icon: 'settings_suggest', viewValue: 'Follow system-design' };


  constructor() { }

  ngOnInit(): void {
  }

}
