pragam solidity ^0.8.26;

contract StructExample{
    stuct Student{
        uint roll;
        string name;
        bool pass;
    }

    Student pubilc s1;

    function insertData(uint _roll,string memory _name,bool _pass){
        s1 = Student(_roll,_name,_pass);

    }
    function returnData() public view returns(Student memory){
        return s1;
    }
    function returnName() public view returns(string memory){
        return s1.name;
    }
    function returnRoll() public view returns(uint){
        return s1.roll;
    }

}