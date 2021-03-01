var ethers = require('ethers');
var TheRealEstate = require('./build/contracts/therealestate.json');

// This is the localhost port Ganache operates on
const url = "http://127.0.0.1:7545";
const provider = ethers.providers.getDefaultProvider(url);

const contractAddress ='0x195Ebee58c65B932FC979E0ff562B38B23b99e8A';

// Connect to the network
// We connect to the Contract using a Provider, so we will only
// have read-only access to the Contract
let contract = new ethers.Contract(contractAddress, TheRealEstate.abi, provider);

try {
	contract.getTokensByOwner(contractAddress).then(msg => console.log(msg));
} catch (e) {
	console.log(e);
}