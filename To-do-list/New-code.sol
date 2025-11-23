// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract demo {
    uint taskCount ;

    struct Task{
    uint id;
    string content;
    bool completed;
    }
    
    mapping(uint=>Task) tasks;

    constructor(){
    taskCount  =1;
     tasks[1] = Task(
        {
          id:1,
          content:"a",
          completed:false
          }
          );
    }
    

    event TaskCreated(uint id,string content,bool completed);

    function createTask(string memory _content) public {
      taskCount ++;
      tasks[taskCount].id = taskCount;
      tasks[taskCount].content = _content;
      tasks[taskCount].completed = false;
      emit TaskCreated(taskCount,_content,false);
    }
    
    event TaskCompleted(uint id,bool completed);

    function toggleTaskCompleted(uint _id) public {
   //  tasks[_id].completed= true;//making the task always true
      tasks[_id].completed = !tasks[_id].completed;
      emit TaskCompleted(_id,tasks[_id].completed);
    } 
     
    function getTask(uint _id) public view returns(uint , string memory, bool){
    // Task memory t = tasks[_id];
   // return (t.id, t.content, t.completed);  
     Task memory t = tasks[_id];
     return (t.id,t.content,t.completed);
    } 

    function getTaskCount() public view returns(uint){
     return taskCount;
    }

   event TaskDeleted(uint id);

   function deleteTask(uint _id) public {
    delete tasks[_id];         // common action

    if (_id == taskCount) {    
        taskCount--;           // only decrement if last task
    }

    emit TaskDeleted(_id);
  }

  /*
   event TaskUpdated(uint id,string content,bool completed);
   function updateTask(uint _id,string memory _content,bool _completed) public {
   //does the task exist
   if(tasks[_id].id != _id  ){ 
    tasks[_id].content = _content;
    tasks[_id].completed = _completed;
     emit TaskUpdated(_id, _content, _completed);
   }
  }
   */ 
   event TaskUpdated(uint id, string content, bool completed);

   function updateTask(uint _id, string memory _content, bool _completed) public {
    require(tasks[_id].id == _id, "Task does not exist");

    tasks[_id].content = _content;
    tasks[_id].completed = _completed;

    emit TaskUpdated(_id, _content, _completed);
   }
   
 }


