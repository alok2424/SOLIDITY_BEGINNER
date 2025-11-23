//SPDX-License-Identifier: MIT
pragam solidity ^0.8.26;

contract StructExample{
   mapping(uint=>string) public studentDetails;

   function insertData(uint _value,uint _key) external{
    studentDetails[_key] =_value;
   }

   function returnElement(uint key) external view returns(string memory){
    return studentDetails[_key];
   }
}