# ERC721 Drop Template

> A simple ERC721 drop implementation, using Forge and Solmate.

This repository extends [Rari Capital's Solmate](https://github.com/Rari-Capital/solmate)'s ERC721 implementation with a payable `mint(uint16 amount)` function, allowing to quickly launch new NFT projects.

### `mint(uint26 amount)`

By default, this function will check the caller has included enough ETH to pay for the mint (see `PRICE_PER_MINT`) and that the total supply hasn't been minted yet (see `TOTAL_SUPPLY`). It doesn't include any checks to limit the amount of tokens an address can buy, since this can be easily bypassed anyways.

## License

This project is open-sourced software licensed under the GNU Affero GPL v3.0 license. See the [License file](LICENSE.md) for more information.
