let provider
let contract
let smartContracts
const confirmations = 7

window.onload = function(e) {
    if (window.ethereum != null) {
        const accountListenerCount = window.ethereum.listenerCount('accountsChanged')
        if (accountListenerCount == 0) {
            window.ethereum.on('accountsChanged', handleAccountsChanged)
        }
        const chainListenerCount = window.ethereum.listenerCount('chainChanged')
        if (chainListenerCount == 0) {
            window.ethereum.on('chainChanged', handleChainChanged);
        }
    }
}

const handleAccountsChanged = async (accounts) => {
    if (accounts.length > 0) {
        await setupContract()
        window.onConnectionChanged(accounts[0], parseInt(window.ethereum.networkVersion))
    } else {
        window.onAccountDisconnected()
    }
}

const handleChainChanged = (chainId) => {
    window.location.reload()
}

function setupSmartContracts(contractsJson) {
    smartContracts = JSON.parse(contractsJson)
}

async function requestAccount() {
    if (window.ethereum == null) {
        window.onProviderMissing(safeStringify({
            code: 'PROVIDER_MISSING',
            message: 'window.ethereum == null',
        }))
        window.onAccountDisconnected()
    } else {
        try {
            await window.ethereum.request({method: 'eth_requestAccounts'})
            await checkConnection()
        } catch (error) {
            window.onRequestingAccountFailed(safeStringify(error))
        }
    }
}

async function checkConnection() {
    if (window.ethereum != null) {
        const accounts = await window.ethereum.request({ method: 'eth_accounts' });
        if (accounts && accounts.length > 0) {
            await setupContract()
            window.onConnectionChanged(accounts[0], parseInt(window.ethereum.networkVersion))
        } else {
            window.onAccountDisconnected()
        }
    } else {
        window.onAccountDisconnected()
    }
}

async function setupContract() {
    provider = new ethers.BrowserProvider(window.ethereum, "any")
    const address = smartContracts[window.ethereum.networkVersion]
    if (address) {
        contract = new ethers.Contract(address, abi, await provider.getSigner())
    }
}

async function changeChain(chainId) {
     try {
        await window.ethereum.request({
            method: 'wallet_switchEthereumChain',
            params: [{ chainId: `0x${chainId.toString(16)}` }],
        });
    } catch (error) {
        window.onChangingChainsFailed(safeStringify(error))
    }
}

async function verifyNft(chainId, rpcUrl, tokenId) {
    const address = smartContracts[chainId]
    const readProvider = new ethers.JsonRpcProvider(rpcUrl)
    const readContract = new ethers.Contract(address, abi, readProvider)
    try {
        const metaData = await readContract.getMetaDataByTokenId(tokenId)
        const nftDetails = {
            chainId: chainId.toString(),
            id: tokenId.toString(),
            value: metaData.value.toString(),
            boughtFor: metaData.boughtFor.toString(),
            boughtAt: metaData.boughtAt.toString(),
            soldFor: metaData.soldFor.toString(),
            soldAt: metaData.soldAt.toString(),
        }
        const owner = await readContract.ownerOf(tokenId)
        window.onNftVerified(safeStringify(nftDetails), owner)
    } catch (error) {
        window.onNftVerificationFailed(safeStringify(error))
    }
}

async function getContractsBalance(chains) {
    let totalNftsValueUsd = BigInt(0);
    let totalSupply = BigInt(0);
    const chainsList = JSON.parse(chains)
    for (const index in chainsList) {
        const chain = chainsList[index];
        const address = smartContracts[chain.chainId]
        if (address) {
            const readProvider = new ethers.JsonRpcProvider(chain.rpcUrl)
            const readContract = new ethers.Contract(address, abi, readProvider)
            totalNftsValueUsd += BigInt((await readContract.getTotalNftsValueUsd()).toString())
            totalSupply += BigInt((await readContract.totalSupply()).toString())
        }
    }
    window.onContractsBalanceLoaded(totalNftsValueUsd.toString(), totalSupply.toString())
}

async function getContractState() {
    try {
        const contractState = {
            mintFee: (await contract.getMintingFee()).toString(),
            minimumValueToMint: (await contract.getMinimumValueToMint()).toString(),
            exchangeRate: (await contract.getExchangeRate()).toString(),
            isPaused: await contract.paused(),
            tokenCounter: (await contract.getTokenCounter()).toString(),
            availableFees: (await contract.getUnwithdrawnFees()).toString(),
            totalNftsValue: (await contract.getTotalNftsValue()).toString(),
        }
        window.onContractStateLoaded(safeStringify(contractState))
    } catch(error) {
        window.onContractStateLoadingFailed(safeStringify(error))
    }
}

async function getMintingSettings() {
    try {
        const address = await provider.getSigner();
        const balance = await provider.getBalance(address)
        const mintingSettings = {
            mintFee: (await contract.getMintingFee()).toString(),
            minimumValueToMint: (await contract.getMinimumValueToMint()).toString(),
            exchangeRate: (await contract.getExchangeRate()).toString(),
            userBalance: balance,
            isPaused: await contract.paused(),
        }
        window.onMintingSettingsLoaded(safeStringify(mintingSettings))
    } catch (error) {
        window.onMintingSettingsFailedToLoad(safeStringify(error))
    }
}

async function getNftsByAddress(address) {
    try {
        const ownerBalance = await contract.balanceOf(address)
        const nftsNumber = parseInt(ownerBalance.toString())
        const userNfts = []
        for (let i = 0; i < nftsNumber; i++) {
            const tokenId = await contract.tokenOfOwnerByIndex(address, i)
            const metaData = await contract.getMetaDataByTokenId(tokenId)
            userNfts.push({
                id: tokenId.toString(),
                chainId: window.ethereum.networkVersion.toString(),
                value: metaData.value.toString(),
                boughtFor: metaData.boughtFor.toString(),
                boughtAt: metaData.boughtAt.toString(),
                soldFor: metaData.soldFor.toString(),
                soldAt: metaData.soldAt.toString(),
            })
        }
        window.onNftListLoaded(safeStringify(userNfts))
    } catch (error) {
        window.onNftListLoadingFailed(safeStringify(error))
    }
}

async function getNftDetails(tokenId) {
    try {
        const metaData = await contract.getMetaDataByTokenId(tokenId)
        const nftDetails = {
            id: tokenId.toString(),
            chainId: window.ethereum.networkVersion.toString(),
            value: metaData.value.toString(),
            boughtFor: metaData.boughtFor.toString(),
            boughtAt: metaData.boughtAt.toString(),
            soldFor: metaData.soldFor.toString(),
            soldAt: metaData.soldAt.toString(),
        }
        const owner = await contract.ownerOf(tokenId)
        window.onNftDetailsLoaded(safeStringify(nftDetails), owner)
    } catch (error) {
        window.onNftDetailsLoadingFailed(safeStringify(error))
    }
}

async function mintNft(value) {
    try {
        const tx = await contract.mintNft({value: value})
        window.onMintTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        const logs = await contract.queryFilter('NftMinted', rc.blockNumber, rc.blockNumber)
        const tokenId = parseInt(logs[0].topics[1], 16).toString()
        const attachedValue = logs[0].topics[2]
        window.onMintTxConfirmed(tokenId, attachedValue)
    } catch (error) {
        window.onMintTxFailed(safeStringify(error))
    }
}

async function cashOutNft(tokenId) {
    try {
        const tx = await contract.cashOutNft(tokenId)
        window.onCashOutTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        const logs = await contract.queryFilter('NftCashedOut', rc.blockNumber, rc.blockNumber)
        const id = logs[0].topics[1]
        const attachedValue = logs[0].topics[2]
        window.onCashOutTxConfirmed(id, attachedValue)
    } catch (error) {
        window.onCashOutTxFailed(safeStringify(error))
    }
}

async function burnNft(tokenId) {
    try {
        const tx = await contract.burnNft(tokenId)
        window.onBurnTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        const logs = await contract.queryFilter('NftBurnt', rc.blockNumber, rc.blockNumber)
        const id = logs[0].topics[1]
        window.onBurnTxConfirmed(id)
    } catch (error) {
        console.error(error)
        window.onBurnTxFailed(safeStringify(error))
    }
}

async function pause() {
    try {
        const tx = await contract.pause()
        window.onPauseTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        window.onPauseTxConfirmed()
    } catch (error) {
        window.onPauseTxFailed(safeStringify(error))
    }
}

async function unPause() {
    try {
        const tx = await contract.unpause()
        window.onUnPauseTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        window.onUnPauseTxConfirmed()
    } catch (error) {
        window.onUnPauseTxFailed(safeStringify(error))
    }
}

async function withdrawFees() {
    try {
        const tx = await contract.withdrawFees()
        window.onWithdrawTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        const logs = await contract.queryFilter('FeesWithdrawn', rc.blockNumber, rc.blockNumber)
        const amount = logs[0].topics[1]
        window.onWithdrawTxConfirmed(amount)
    } catch (error) {
        window.onWithdrawTxFailed(safeStringify(error))
    }
}

async function setNewMintFee(newMintFee) {
    try {
        const tx = await contract.setMintingFee(newMintFee)
        window.onNewMintFeeTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        window.onNewMintFeeTxConfirmed(newMintFee)
    } catch (error) {
        window.onNewMintFeeTxFailed(safeStringify(error))
    }
}

async function setNewMinimumValueToMint(newMinimumValueToMint) {
    try {
        const tx = await contract.setMinimumValueToMint(newMinimumValueToMint)
        window.onNewMinimumValueToMintTxSent(tx.hash, confirmations)
        const rc = await tx.wait(confirmations)
        window.onNewMinimumValueToMintTxConfirmed(newMinimumValueToMint)
    } catch (error) {
        window.onNewMinimumValueToMintTxFailed(safeStringify(error))
    }
}

async function downloadNft(fileName, x, y, width, height) {
    try {
        var canvas = await html2canvas(document.body, {
            x: x,
            y: y,
            width: width,
            height: height,
            scale: 1,
            imageTimeout: 105000,
        });
        canvas.toBlob(
            (blob) => {
                downloadBlob(blob, `${fileName}.png`)
                window.onDownloaded()
            }
        )
    } catch (error) {
        console.error(error)
        window.onDownloadingFailed(
            safeStringify({ code: error.name, message: error.message }),
        )
    }
}

function downloadBlob(blob, fileName) {
    var url = window.URL.createObjectURL(blob);
    var a = document.createElement("a");
    document.body.appendChild(a);
    a.style = "display: none";
    a.target = "_blank";
    a.href = url;
    a.download = fileName;
    a.click();
    window.URL.revokeObjectURL(url);
}

function safeStringify(object) {
    return JSON.stringify(object, (key, value) =>
        typeof value === 'bigint'
            ? value.toString()
            : value
    );
}
