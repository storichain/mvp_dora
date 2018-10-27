// Import the page's CSS. Webpack will know what to do with it.
//import "../styles/app.css"

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import storychain_artifacts from '../../build/contracts/StoryChain.json'

var StoryChain = contract(storychain_artifacts);

var candidates = {};

var tokenPrice = null;

window.App = {
 start: function() {
  var self = this;

  // Bootstrap the MetaCoin abstraction for Use.
  StoryChain.setProvider(web3.currentProvider);

 },

    setDialogue: function() {
        let dialog = $("#dialog").val();
        $("#msg").html("Data has been submitted. The data count will increment as soon as the data is recorded on the blockchain. Please wait.")
        $("#dialog").val("");

        StoryChain.deployed().then(function(contractInstance) {
            contractInstance.setDialogue(dialog, {gas: 1140000, from: web3.eth.accounts[0]}).then(function() {
                return contractInstance.getDialoguesCount.call().then(function(v) {
                    $("#msg").html(v.toString());
                });
            });
        });
    },

    support: function() {
        let dialog = $("#dialog").val();
        dialog = new BigNumber(dialog);
        //convert from ETH/18 DECIMAL TOKEN to WEI
        dialog = web3.toWei(dialog, "ether");
        $("#msg").html("Data has been submitted. The data count will increment as soon as the data is recorded on the blockchain. Please wait.")
        $("#dialog").val("");

        StoryChain.deployed().then(function(contractInstance) {
            contractInstance.support(dialog, {gas: 240000, from: web3.eth.accounts[0]}).then(function() {
                return contractInstance.getBalance.call().then(function(v) {
                    let remain = web3.toWei(v, "ether");
                    $("#msg").val(remain.toString());
                });
            });
        });
    }

};

window.addEventListener('load', function() {
 // Checking if Web3 has been injected by the browser (Mist/MetaMask)
 if (typeof web3 !== 'undefined') {
  console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
  // Use Mist/MetaMask's provider
  window.web3 = new Web3(web3.currentProvider);
 } else {
  console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
  // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
  window.web3 = new Web3(new Web3.providers.HttpProvider('http://1.237.42.87:8545'));
 }

 App.start();
});
