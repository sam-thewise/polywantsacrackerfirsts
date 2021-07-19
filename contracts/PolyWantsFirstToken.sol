// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.2/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./libs/Authorizable.sol";


contract PolyWantsACrackerFirstsToken is ERC721Enumerable, Authorizable{
 
    struct NameUrlPair{
        string name;
        string url;
    }
    
    mapping( uint256 => NameUrlPair ) _nameUrlPairs;
    
    uint256 _tokenId;
    
    function _getTokenIdsForAddress(address addressToGetTokens ) private view returns( uint256[] memory addressTokenIds ){
        uint256 tokenCount = balanceOf(addressToGetTokens);

        if (tokenCount == 0) {
            return new uint256[](0);
        } 
        
        uint256[] memory result = new uint256[](tokenCount);
       
        uint256 tokenIndex;

        for (tokenIndex = 0; tokenIndex < tokenCount; tokenIndex++) {
            result[tokenIndex] = tokenOfOwnerByIndex(addressToGetTokens,tokenIndex);
        }

        return result;
    }
    
    constructor() ERC721( 'Poly Wants a Cracker Firsts', 'PWAC1ST' ){
        
    }
    
    function addFirst( address recipient, string memory name, string memory url ) public onlyAuthorized{
        _tokenId++;
        
        _nameUrlPairs[_tokenId] = NameUrlPair( {name: name, url: url } );
        
        _safeMint( recipient, _tokenId );
    }
    
     function getNameUrlDetails( uint256 tokenId ) external view returns( NameUrlPair memory ){
        return _nameUrlPairs[tokenId];
    }
    
     function tokenIdsOfOwner(address owner) external view returns(uint256[] memory ownerTokens) {
        return _getTokenIdsForAddress(owner);
    }
    
    function nameUrlPairsOfOwner(address owner) external view returns( NameUrlPair[] memory addressNameUrls ){
        uint256[] memory tokenIdsForOwner = _getTokenIdsForAddress(owner);
        
        uint256 tokenCount = tokenIdsForOwner.length;
        
        if( tokenCount == 0){
            return new NameUrlPair[](0);
        }
        
        NameUrlPair[] memory results = new NameUrlPair[](tokenCount);
        
        uint256 tokenIndex;
        
        for (tokenIndex = 0; tokenIndex < tokenCount; tokenIndex++) {
            uint256 tokenId = tokenIdsForOwner[tokenIndex];
            
            results[tokenIndex] = _nameUrlPairs[tokenId];
        }
        
        return results;
    }
    
}