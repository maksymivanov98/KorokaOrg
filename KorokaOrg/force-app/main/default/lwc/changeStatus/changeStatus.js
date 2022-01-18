import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getProjectTask from '@salesforce/apex/ProjectTaskController.getProjectTask';
import updateTask from '@salesforce/apex/ProjectTaskController.updateTask';

import deleteTask from '@salesforce/apex/ProjectTaskController.deleteTask';



import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ChangeStatus extends NavigationMixin(LightningElement) {

    @track taskNewList = [];
    @track taskInProgressList = [];
    @track taskCompletedList = [];
    @track dropTaskId;

    @api recordId;
    @track getidrecord;


    connectedCallback(){
        this.getTaskData();
    }

    getTaskData(){
        getProjectTask({recordId : this.recordId }).then(result =>{
            let taskNewData = [];
            let taskInProgressData = [];
            let taskCompletedData = [];
            for(let i = 0; i < result.length; i++){
                let task = new Object();
                task.Id = result[i].Id;
                task.Name = result[i].Name;
                task.Status__c = result[i].Status__c;
 
                if(task.Status__c === 'New'){
                    taskNewData.push(task);
                }else if(task.Status__c !== 'New' && task.Status__c !== 'Completed'){
                    taskInProgressData.push(task);
                }else if(task.Status__c === 'Completed'){
                    taskCompletedData.push(task);
                }
            }
            this.taskNewList = taskNewData;
            this.taskInProgressList = taskInProgressData;
            this.taskCompletedList = taskCompletedData;
        }).catch(error => {
            window.alert('$$$Test1:'+ error);
        })
    }

    taskDragStart(event){
        const taskId = event.target.id.substr(0,18);
        //window.alert(taskId);
        this.dropTaskId = taskId;
        let draggableElement = this.template.querySelector('[data-id="' + taskId + '"]');
      //  draggableElement.classList.add('drag');
        this.handleTaskDrag(taskId);
    }

    taskDragEnd(event){
        const taskId = event.target.id.substr(0,18);
        //window.alert(taskId);
        let draggableElement = this.template.querySelector('[data-id="' + taskId + '"]');
      //  draggableElement.classList.remove('drag');
    }

    handleDrop(event){
        this.cancel(event);
        const columnUsed = event.target.id;
        let taskNewStatus;
        if(columnUsed.includes('InProgress')){
            taskNewStatus = 'InProgress';
        }else if(columnUsed.includes('New')){
            taskNewStatus = 'New';
        }else if(columnUsed.includes('Completed')){
            taskNewStatus = 'Completed';
        }
        //window.alert(columnUsed + ' & '+ taskNewStatus);
        this.updateTaskStatus(this.dropTaskId, taskNewStatus);
        let draggableElement = this.template.querySelector('[data-role="drop-target"]');
       // draggableElement.classList.remove('over');
    }

    handleDragEnter(event){
        this.cancel(event);
    }

    handleDragOver(event){
        this.cancel(event);
        let draggableElement = this.template.querySelector('[data-role="drop-target"]');
      //  draggableElement.classList.add('over');
    }

    handleDragLeave(event){
        this.cancel(event);
        let draggableElement = this.template.querySelector('[data-role="drop-target"]');
      //  draggableElement.classList.remove('over');
    }

    handleTaskDrag(taskId){
        console.log('$$$TEst: '+ taskId);
    }

    updateTaskStatus(taskId, taskNewStatus){
        updateTask({newTaskId: taskId, newStatus: taskNewStatus}).then(result =>{
            this.getTaskData();
        }).catch(error =>{
            window.alert('$$$Test2:'+ JSON.stringify(error));
        })
    }

    cancel(event) {
        if (event.stopPropagation) event.stopPropagation();
        if (event.preventDefault) event.preventDefault();
        return false;
    };

    handleClick(event){ //button delete;
        const taskId = event.target.id.substr(0,18);
        this.getidrecord = taskId;
        this.goToRecordPage(this.getidrecord);
    }
    goToRecordPage(taskId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: taskId,
                objectApiName: 'Project_Task__c',
                actionName: 'view'
            }
        });
    }
    editRecordStatus(event){ //button delete;
        const taskId = event.target.id.substr(0,18);
        this.getidrecord = taskId;
        this.editRecord(this.getidrecord);
    }
    editRecord(taskId){
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: taskId,
                actionName: "edit"
            }  
        });
    }
    deleteTaskStatus(event){
        const taskId = event.target.id.substr(0,18);
        this.getidrecord = taskId;
        if (confirm('Are you sure you want to delete this record?')) {
            this.deleteTask(this.getidrecord);
          } else {
            // false
          }
        
        
    }
    deleteTask(taskId){
        deleteTask({newTaskId: taskId}).then(result =>{
            this.getTaskData();
        });
    }


    getId(event) {
        const taskId = event.target.id.substr(0,18);
        this.getidrecord = taskId;
        //this.showToast(this.getidrecord);
        //this.deleteTaskStatus(this.getidrecord);
    }


    showToast(taskId) {
        const event = new ShowToastEvent({
            title: 'Toast message',
            message: taskId,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    
}