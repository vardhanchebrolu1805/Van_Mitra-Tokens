module.exports = {
  networks: {
    // Network for Ganache (for local development)
    development: {
      host: "127.0.0.1",   // Localhost
      port: 8545,          // Default port for Ganache Desktop (or 8545 for Ganache CLI)
      network_id: "*",     // Any network ID (default is * for any network)
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.21",  // Ensure this matches the Solidity version you're using
    }
  },
};
