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

   //how to initialise value in constructor
    constructor(){
     Task.id = 1;
     Task.content= "abc";
     Task.completed = false;
    }
    
    event()
    //how to assign value of parameter of struct inside function
    function createTask(string memory _content) public {
      taskCount ++;
      Task[id] = taskCount;
      Task[content] = _content;
      Task[completed] = false;

      emit()
    }
     
    
    function toggleTaskCompleted(uint _id) public {
     tasks[
    } 

    //How to return multiple parameters from a function 
    function getTask(uint _id) public returns(){
    
    } 

    function getTaskCount() public view returns(uint){
    return taskCount;
    }
    //syntax of event- emit
}


