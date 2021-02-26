var theRealEstate;
var userAccount;

function startApp() {
  var theRealEstateAddress = "0x195Ebee58c65B932FC979E0ff562B38B23b99e8A";
  theRealEstate = new web3js.eth.Contract(theRealEstateABI, theRealEstateAddress);

  var accountInterval = setInterval(function() {
    // Check if account has changed
    if (web3.eth.accounts[0] !== userAccount) {
      userAccount = web3.eth.accounts[0];
      // Call a function to update the UI with the new account
      getTokensByOwner(userAccount)
      .then(displayTokens);
    }
  }, 100);

  // Start here
}

function displayTokens(ids) {
  $("#tokens").empty();
  for (id of ids) {
    // Look up token details from our contract. Returns a `token` object
    getTokenDetails(id)
    .then(function(token) {
      // Using ES6's "template literals" to inject variables into the HTML.
      // Append each one to our #token div
      $("#tokens").append(`<div class="token">
        <ul>
          <li>Name: ${token.name}</li>
          <li>Adress: ${token.adress}</li>
          <li>Price: ${token.price}</li>
          <li>Image link: ${token.imageLink}</li>
        </ul>
      </div>`);
    });
  }
}

function createToken(name, adress, price, imageLink) {
  // This is going to take a while, so update the UI to let the user know
  // the transaction has been sent
  $("#txStatus").text("Adding your token to your account, please wait...");
  // Send the tx to our contract:
  return theRealEstate.methods._createToken(name, adress, price, imageLink)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Successfully added " + name + "!");
    // Transaction was accepted into the blockchain, let's redraw the UI
    getTokensByOwner(userAccount).then(displayTokens);
  })
  .on("error", function(error) {
    // Do something to alert the user their transaction has failed
    $("#txStatus").text(error);
  });
}


function buyToken(tokenId) {
  $("#txStatus").text("Buying token...");
  return theRealEstate.methods._transferFrom(tokenId)
  .send({ from: userAccount, value: web3.utils.toWei(getTokenDetails(id).price, "ether") })
  .on("receipt", function(receipt) {
    $("#txStatus").text("You just bought a new house!");
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });
}

function getTokenDetails(id) {
  return theRealEstate.methods.tokens(id).call()
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

window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // Handle the case where the user doesn't have Metamask installed
    // Probably show them a message prompting them to install Metamask
  }

  // Now you can start your app & access web3 freely:
  startApp()

})