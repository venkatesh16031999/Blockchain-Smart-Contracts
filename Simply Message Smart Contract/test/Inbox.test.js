const assert=require("assert");
const ganache=require("ganache-cli");
const Web3=require("web3");
const web3=new Web3(ganache.provider());

const { interface,bytecode } =require("../compile");

let accounts;
let inbox;

beforeEach( async ()=>{

    accounts= await web3.eth.getAccounts();

    inbox= await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data: bytecode,arguments: ['Hello'] })
    .send({from:accounts[0],gas:1000000});

});

describe("Inbox", async ()=>{
    it("Checking",()=>{
        assert.ok(inbox.options.address);
    })

    it("Has Default message",async ()=>{
        let message=await inbox.methods.message().call();
        assert.equal(message,'Hello');
    })

    it("Updating the message",async ()=>{
        await inbox.methods.setMessage('bye').send({from:accounts[0]});
        let message=await inbox.methods.message().call();
        assert.equal(message,'bye');
    })

})