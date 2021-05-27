#### Covenantc2, puppyc2 and Octopus

  Octopus is an open source, pre-operation C2 server based on python which can control an Octopus powershell agent through HTTP/S.

  Octopus works in a very simple way to execute commands and exchange information with the C2 over a well encrypted channel, which makes it inconspicuous and undetectable from almost every AV, endpoint protection, and network monitoring solution.

  Octopus is designed to be stealthy and covert while communicating with the C2, as it uses AES-256 by default for its encrypted channel between the powershell agent and the C2 server. You can also opt for using SSL/TLS by providing a valid certficate for your domain and configuring the Octopus C2 server to use it.




# Credits

* [Ian Lyte](https://twitter.com/Bb_hacks) for reporting multiple bugs in Octopus and pushing an enhanced AMSI bypass module.

* [Khlief](https://github.com/ahmedkhlief) for adding HTA module and fix a bug in download feature

* [Moath Maharmah](https://twitter.com/iomoaaz) for enhancing the encryption module and writing a standalone C# Octopus agent which will be added to the upcoming release.

* [TeslaPulse](https://github.com/TeslaPulse/) for testing Octopus

* [J005](https://github.com/iomoath) for adding enhanced Powershell oneliner and fix an issue in the HID attack script.



# License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details
