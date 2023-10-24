// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Upload
{
    struct Access{
        address user;
        bool access;
    }
    mapping(address=>string[]) value;
    mapping(address=>mapping(address=>bool)) ownership;
    mapping (address=>Access[]) accesslist;
    mapping(address=>mapping(address=>bool)) previousdata;

    function add(address _user,string memory url) external
    {
        value[_user].push(url);
    } 
    function allow(address _user) external {
        ownership[msg.sender][_user]=true;
        if(previousdata[msg.sender][_user])
        {
            for(uint i=0;i<accesslist[msg.sender].length;i++)
            {
                if(accesslist[msg.sender][i].user==_user)
                {
                    accesslist[msg.sender][i].access=true;
                }
            }
        }
        else 
        {
            accesslist[msg.sender].push(Access(_user,true));
            previousdata[msg.sender][_user]=true;

        }
    }
    function disallow(address _user) public {
        ownership[msg.sender][_user]=false;
        for(uint i=0;i<accesslist[msg.sender].length;i++)
        {
            if(accesslist[msg.sender][i].user==_user)
            {
                accesslist[msg.sender][i].access=false;
            }
        }
    }

    function display(address _user) external view returns(string[] memory )
    {
        require(_user==msg.sender||ownership[_user][msg.sender],"You are not Authorized to view");
        return value[_user];
    }

    function shareAccess() public view returns(Access[] memory)
    {
        return accesslist[msg.sender];
    }


}