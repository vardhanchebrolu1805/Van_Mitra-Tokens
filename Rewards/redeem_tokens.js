const Web3 = require('web3');
const readlineSync = require('readline-sync'); // For input from user
const fs = require('fs'); // For reading JSON file

// Web3 setup
const web3 = new Web3('http://127.0.0.1:8545'); // Ganache local network

// Contract details (replace with your contract address and ABI)
const contractAddress = '0x92ac59E9Ad6C557Eb647Eb7210e2F1a75cB6bD49'; // Replace with your actual contract address

// Replace with your actual contract ABI
const contractABI = [
    {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {"name": "userId", "type": "uint256"},
            {"name": "tokensToRedeem", "type": "uint256"}
        ],
        "name": "redeemTokens",
        "outputs": [{"name": "success", "type": "bool"}],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    }
]; // Replace with your actual contract ABI

const contract = new web3.eth.Contract(contractABI, contractAddress);

// Use an account provided by Ganache
let account;
async function initializeAccount() {
    const accounts = await web3.eth.getAccounts(); // Get Ganache accounts
    account = accounts[0]; // Use the first account
}

// Read the top50Users.json file
let top50Users;
try {
    top50Users = JSON.parse(fs.readFileSync('C:/Users/vardh/VanMitraProject/top50Users.json', 'utf8'));
} catch (error) {
    console.error("Error reading the JSON file:", error);
    process.exit(1);
}

// Ask for user input (User ID and tokens to redeem)
const userId = readlineSync.question('Enter User ID: ');

// Find the user from the top50Users data
const user = top50Users.find(user => user["User ID"] === userId);

async function main() {
    await initializeAccount(); // Initialize account from Ganache

    if (user) {
        if (user["Plants Planted"] >= 1000) {
            console.log('User is eligible!');
            const tokensToRedeem = readlineSync.question('Enter number of tokens to redeem: ');

            // Convert tokens to number
            const tokensToRedeemNumber = parseInt(tokensToRedeem);
            const saplingsRedeemed = Math.floor(tokensToRedeemNumber / 10); // 1 sapling per 10 tokens

            console.log(`User redeemed ${saplingsRedeemed} saplings.`);

            // Call the smart contract to redeem the tokens
            await redeemTokens(parseInt(userId.replace("User_", "")), tokensToRedeemNumber);
        } else {
            console.log('User is not eligible (less than 1000 plants planted).');
        }
    } else {
        console.log('User not found.');
    }
}

async function redeemTokens(userIdNumber, tokensToRedeemNumber) {
    try {
        // Estimate gas before sending the transaction
        const gasEstimate = await contract.methods.redeemTokens(userIdNumber, tokensToRedeemNumber).estimateGas({ from: account });

        // Call the redeemTokens function from the contract
        const result = await contract.methods.redeemTokens(userIdNumber, tokensToRedeemNumber).send({ 
            from: account,
            gas: gasEstimate 
        });

        // Output the result
        console.log('Transaction successful:', result);
    } catch (error) {
        console.error('Error interacting with the contract:', error);
    }
}

// Run the main function
main();
