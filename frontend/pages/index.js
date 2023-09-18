import { useState, useEffect } from 'react';
import { ethers } from 'ethers'; // Import ethers.js
import Web3Modal from 'web3modal';
//import { abi, NFT_CONTRACT_ADDRESS } from "../constants";
import styles from "../styles/Home.module.css";

export default function Home() {
    const [provider, setProvider] = useState(null); // Replace 'web3' with 'provider'
    const [contractInstance, setContractInstance] = useState(null);
    const [account, setAccount] = useState(null);

    useEffect(() => {
        const initEthereum = async () => {
            const web3Modal = new Web3Modal();

            try {
                // Connect to a wallet using Web3Modal
                const ethProvider = await web3Modal.connect();

                // Create an ethers.js provider using the selected Ethereum provider
                const ethersProvider = new ethers.providers.Web3Provider(ethProvider);

                // Get the current account's address
                const signer = ethersProvider.getSigner();
                const currentAccount = await signer.getAddress();

                // Set the provider, signer, and account in the component state
                setProvider(ethersProvider);
                setAccount(currentAccount);
                
                // Initialize and set your contract instance here
                // For example:
                // const contractAddress = 'YOUR_CONTRACT_ADDRESS';
                // const contractABI = [...]; // Your contract's ABI
                // const contractInstance = new ethers.Contract(contractAddress, contractABI, signer);
                // setContractInstance(contractInstance);
            } catch (error) {
                console.error('Error connecting to Ethereum:', error);
            }
        };

        initEthereum();
    }, []);

    // Function to handle agricultural contract activities
    async function handleAgriculturalContractActivity() {
        if (contractInstance) {
            // Perform actions on the agricultural contract here
            // Example: listing produce, investing, delivering produce, etc.
        }
    }

    // Function to handle insurance contract activities
    async function handleInsuranceContractActivity() {
        if (contractInstance) {
            // Perform actions on the insurance contract here
            // Example: purchasing insurance, submitting claims, etc.
        }
    }

    return (
      <div className="container">
          <header>
              <h1>Web3 Solidity Project</h1>
              {account && <p>Connected Account: {account}</p>}
              <button className="button" onClick={handleAgriculturalContractActivity}>
                  Agricultural Contract Activity
              </button>
              <button className="button" onClick={handleInsuranceContractActivity}>
                  Insurance Contract Activity
              </button>
          </header>
      </div>
    );
  
}
