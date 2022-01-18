import { LightningElement } from 'lwc';
import runEvent from '@salesforce/apex/RunEvent.addNotification';

export default class RunEvent extends LightningElement {

    run() {
        runEvent({numberNotif : this.template.querySelector('lightning-input').value });     
    }
}