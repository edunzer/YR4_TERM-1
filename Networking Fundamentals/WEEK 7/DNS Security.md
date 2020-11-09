## DNS SECURITY

1. Perform some research on the Internet in regards to DNS security vulnerabilities

2. Two commonly exploited DNS vulnerabilities and discuss the impact on the network and its users

3. How these vulnerabilities are being mitigated or controlled


  - DNS servers are able to share information like a book to anyone who asks. This can be exploited and creates a great source of information for hackers when there trying to find internal information. Then after this the possibility that you can get into the DNS server and change the records that it has recorded allows for very basic rerouting hacks that bring the users to the wrong address, allowing for more vulnerabilities.

    >"For example, an inherent vulnerability occurs when a name server allows recursive
    queries from arbitrary IP addresses. This approach is vulnerable to cache-poisoning
    attacks, in which a hacker can induce the name server to cache fabricated data."

  - Many new attacks take advantage of the most common factor in DNS hacking which is failure. TCP SYN Flood Attacks use this method by flooding DNS server with new TCP connection requests until the target machine fails. A UDP Flood Attack sends a large number of UDP packets to a random port on the targeted host to confuse or overwhelm the target machine until it fails. After these fails take place the opportunity to take over and then launch a Man in the Middle Attack where  a compromised machine in the network can penetrate and take over the entire DNS structure and then route legitimate requests to malicious websites.

  - The biggest part of DNS vulnerability protection seems to be just better security in the first place. Many articles that I read suggested that many happen because people cant configure, don't know how to, or just don't put enough security into there networks. Many attacks can be prevented by only allowing certain computers on the network to access the networks higher functions, along with using all protections that are built into DNS software. Having a DDOS mitigation service often is a greatest protection for most smaller organizations.
