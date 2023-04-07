<div align="center">
    <h1>MyWallet</h1>
    <p align="center">
        An ERC-1155 token transfer and explorer.
    </p>
</div>

<details>
    <summary>Table of Contents</summary>
    <ol>
        <li>
            <a href="#about-the-project">About The Project</a>
            <ul>
                <li><a href="#built-with">Built With</a></li>
            </ul>
        </li>
        <li>
            <a href="#getting-started">Getting Started</a>
            <ul>
                <li><a href="#installation">Installation</a></li>
            </ul>
        </li>
        <li><a href="#usage">Usage</a></li>
        <li><a href="#contributing">Contributing</a></li>
        <li><a href="#license">License</a></li>
    </ol>
</details>

## About The Project

![](https://github.com/91d906h4/MyWallet/blob/master/Asset/mywallet.gif)

This is a tiny dApp that you can transfer "MyWallet" ERC-1155 tokens or view the balance with.

The web server is built with flask (Python) and hosted as a hiddedn service.

### Built With

MyWallet is built with the following tools:

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

![jQuery](https://img.shields.io/badge/jquery-%230769AD.svg?style=for-the-badge&logo=jquery&logoColor=white)

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

![Tor](https://img.shields.io/badge/Tor-7D4698?style=for-the-badge&logo=Tor-Browser&logoColor=white)

![Bootstrap](https://img.shields.io/badge/bootstrap-%23563D7C.svg?style=for-the-badge&logo=bootstrap&logoColor=white)

![Solidity](https://img.shields.io/badge/Solidity-%23363636.svg?style=for-the-badge&logo=solidity&logoColor=white)



## Getting Started

You can simple built a docker image with the Dockerfile.

### Installation

1. Clone the repository from GitHub.
```sh
git clone https://github.com/91d906h4/MyWallet.git
```
```sh
cd .\MyWallet\
```

2. Build an image with the Dockerfile.
```sh
docker image build -t mywallet-server .
```

3. Run the image.
```sh
docker run -dp 20000:10000 mywallet-server
```
(Notice that the internal port is 10000.)

3. Start the hiiden service.
(The port of hidden service is 20000 in the previous step.)

## Usage

Just access the hidden service via Tor Browser and start to transfer your MyWallet tokens.

## License

Distributed under the MIT License. See [LICENSE.txt](https://github.com/91d906h4/MyWallet/blob/master/LICENSE) for more information.
