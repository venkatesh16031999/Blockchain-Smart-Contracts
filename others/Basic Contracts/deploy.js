const HdWallet=require("truffle-hdwallet-provider");
const Web3=require("web3");


const { interface,bytecode } =require("./compile");

const provider=new HdWallet(
    'celery repair prize hole fruit predict stick weekend loyal dog tray riot',
    'https://rinkeby.infura.io/v3/882ea730459b4a0baa7d8488e1a1a16e'
);

const web3=new Web3(provider);

const deploy=async ()=>{

    let accounts= await web3.eth.getAccounts();

    let inbox= await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data: bytecode,arguments: ['Hello'] })
    .send({gas:1000000,from:accounts[0]});

    console.log(inbox);

}

deploy();
