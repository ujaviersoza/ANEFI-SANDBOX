/* c/myModal.js */
import { api } from 'lwc';
import LightningModal from 'lightning/modal';
export default class MyModal extends LightningModal {
    handleOkay() {
        this.close('okay');
    }
}