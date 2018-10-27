pragma solidity  ^0.4.24;

contract StoryChain  {
    struct DialogueInfomation {
        uint nid;
        string dialogText;  //(텍스트 대사)
        //string dialogImage;//(이미지대사)
        //string urlAddress; //(대사 속 URL)
    }
    DialogueInfomation[] public dialogues;

    address public owner;
    uint id ;
    uint c_id;

    constructor() public {
        owner = msg.sender;
        id=0;
    }

    function _setDialogue(uint _nid, string _dialogText) internal {
        id = dialogues.push(DialogueInfomation(_nid, _dialogText)) ;
    }

    function setDialogue(string _dialogText) public onlyOwner {
        c_id = id+1;  //later openzepplen
        _setDialogue(c_id, _dialogText);
    }

    function getDialoguesCount() public constant onlyOwner  returns(uint) {
        return id;
    }

    function getDialogue(uint r_id) public constant  returns(string) {

        return dialogues[r_id].dialogText;
    }

    function getLastDialogue() public constant onlyOwner returns(string) {
        uint num;
        num = getDialoguesCount()-1;
        if (num<0) {
            num=0;
        }
        return dialogues[num].dialogText;
    }

    function support(uint _amount) public payable onlyOwner {
        uint my_bal;
        my_bal = msg.sender.balance;
        require(my_bal>= _amount);
        address(this).send(_amount);
    }

    function getBalance() public view returns(uint) {
        return msg.sender.balance;
    }

    function getStoryBalance() public view returns(uint) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
