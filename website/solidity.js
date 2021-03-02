var web3js;
var theRealEstate;
var userAccount;

async function startApp() {
    await loadMetamask()
    var theRealEstateAddress = "0x948f9902d7654BE628BDDe0cA276899f982E812D";
    theRealEstate = new web3js.eth.Contract(theRealEstateABI, theRealEstateAddress);
    $("#txStatus").text("Account : " + userAccount);
    var accountInterval = setInterval(function () {
        // Check if account has changed
        if (web3js.eth.accounts[0] !== undefined && web3js.eth.accounts[0] !== userAccount[0]) {
            userAccount[0] = web3js.eth.accounts[0];
            // Call a function to update the UI with the new account
            getTokensByOwner(userAccount[0])
                .then(displayTokens);
        }
    }, 100);

    // Start here
    var val = getTokensByOwner(userAccount[0]);
    console.log(val);
    
                //.then(displayTokens);
}

function displayTokens(ids) {
    $("#tokens").empty();
    for (id of ids) {
        // Look up token details from our contract. Returns a `token` object
        getTokenDetails(id)
            .then(function (token) {
                // Using ES6's "template literals" to inject variables into the HTML.
                // Append each one to our #token div
                $("#tokens").append(`<div class="token">
              <ul>
                <li>Name: ${token.name}</li>
                <li>Adress: ${token.adress}</li>
                <li>Adress: ${token.description}</li>
                <li>Price: ${token.price}</li>
                <li>Image link: ${token.imageLink}</li>
              </ul>
            </div>`);
            });
    }
}

function createToken(name, adress, description, price, imageLink) {
    // This is going to take a while, so update the UI to let the user know
    // the transaction has been sent
    $("#txStatus").text("Adding your token to your account, please wait...");
    // Send the tx to our contract:
    return theRealEstate.methods._createToken(name, adress, description, price, imageLink)
        .send({from: userAccount[0]})
        .on("receipt", function (receipt) {
            $("#txStatus").text("Successfully added " + name + "!");
            // Transaction was accepted into the blockchain, let's redraw the UI
            getTokensByOwner(userAccount).then(displayTokens);
        })
        .on("error", function (error) {
            // Do something to alert the user their transaction has failed
            $("#txStatus").text(error);
        });
}


function buyToken(tokenId) {
    $("#txStatus").text("Buying token...");
    return theRealEstate.methods._transferFrom(tokenToOwner(tokenId), userAccount,  tokenId)
        .send({from: userAccount, value: web3js.utils.toWei(getTokenDetails(tokenId).price, "ether")})
        .on("receipt", function (receipt) {
            $("#txStatus").text("You just bought a new house!");
        })
        .on("error", function (error) {
            $("#txStatus").text(error);
        });
}

function getTokenDetails(id) {
    return theRealEstate.methods.getToken(id).call()
}

function tokenToOwner(id) {
    return theRealEstate.methods.tokenToOwner(id).call()
}

function getTokensByOwner(owner) {
    return theRealEstate.methods.getTokensByOwner(owner).call()
}

function getTokensOnSaleByOwner(owner) {
    return theRealEstate.methods.getTokensOnSaleByOwner(owner).call()
}

async function loadMetamask() {
    userAccount = await window.ethereum.request({ method: 'eth_requestAccounts' });
    web3js.eth.accounts[0] = userAccount[0];
    web3js.eth.defaultAccount = userAccount[0];
    $("#txStatus").text("Account : " + userAccount);
}

window.addEventListener('load', function () {

    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    // Modern DApp Browsers
    if (window.ethereum) {
       web3js = new Web3(window.ethereum);
       try { 
            startApp();
              // User has allowed account access to DApp...

       } catch(e) {
          // User has denied account access to DApp...
       }
    }
    // Legacy DApp Browsers
    else if (window.web3) {
        web3 = new Web3(web3.currentProvider);
        startApp();
    }
    // Non-DApp Browsers
    else {
        alert('You have to install MetaMask !');
    }

    // Now you can start your app & access web3 freely:
    
})