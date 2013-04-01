TimeStampScript
================
这是用来给文件创建*可信时间戳*的工具
##关于时间戳
下面引用[tsa.cn](http://www.tsa.cn/info/171090_186966.vm "tsa.cn")上的一段说明，更多信息可以参考[WIKI](http://en.wikipedia.org/wiki/Trusted_timestamping "Trusted_timestamping")

>*可信时间戳*通过固化电子数据的有效性（内容完整性和存在时间点），达到防止电子数据内容和签署时间被伪造和篡改的目的，有效解决电子数据如何等同于传统书面证据问题，符合《电子签名法》相关规定。

>在数字版权保护、知识产权保护等领域，通过为电子文件加盖可信时间戳获得具有法律效力的电子文件权属证明，在电子商务、电子医疗、电子政务等领域，通过为电子合同、电子病历、电子公文等电子文件加盖时间戳，确定电子文件确切的签署时间，防止数字签名伪造，达到“不可否认”或“抗抵赖”的目的。

*注意，这个软件仅用于测试和学习软件开发技术，并不保证所创建的时间戳的可靠性、法律效力等。作者不承担任何责任，亦不承担相应的法律责任，产生的任何后果或损失由使用者自己承担。*

##作者
**Hugo Qin** [@github](https://github.com/FireUponSKy)

##许可证
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
##使用方法
将需要创建数字签名的文件包括其绝对路径添加到files.list文件里，例如
<pre><code>
./abc.txt
it.pdf
/home/document/is.tex
......
</code></pre>
每一行一个文件，然后执行main.sh
<pre><code>
su ./main
</code></pre>
屏幕上会有这样的输出
<pre><code>
----------abc.txt---BEGIN----------
SHA1:01a07e08781ab809345d3b691e2e788381d0ca32
----------Timestamping Info----------
Status info:
Status: Granted.
Status description: unspecified
Failure info: unspecified

TST info:
Version: 1
Policy OID: 1.3.6.1.4.1.6449.2.1.1
Hash Algorithm: sha256
Message data:
    0000 - ff 59 9e a5 cd 57 ea ed-9f c9 44 60 af 64 97 d5   .Y...W....D`.d..
    0010 - b0 ea 9a 23 bc 2b aa e5-93 10 ce b5 ec 88 a6 12   ...#.+..........
Serial number: 0xF919D095CE5D21E9CD880B701B73B2B751B7FCA2
Time stamp: Mar 31 16:25:38 2013 GMT
Accuracy: unspecified
Ordering: no
Nonce: 0x244F214A3802AA3B
TSA: DirName:/C=GB/ST=Greater Manchester/L=Salford/O=COMODO CA Limited/CN=COMODO Time Stamping Signer
Extensions:
----------Verification----------
Verification: OK
----------abc.txt---END----------

......
</code></pre>
这段信息不仅会在屏幕上输出，还会输出到<code>log</code>文件中。被创建时间戳的文件自动备份到<code>backup</code>目录中，而创建的时间戳文件以<code>.tsr</code>为扩展名放在<code>timestamp</code>目录中。

上面的信息里
<pre><code>
----------Verification----------
Verification: OK
</code></pre>
说明时间戳创建成功并已经验证通过。

可以看到，默认使用的是COMODO的时间戳服务器，这本是用来给程序添加时间戳的，用在这里应该也足够权威。但对某些类型的文档或作品，你可能需要使用其他可信时间戳服务器才能获得有效的法律效力（很多是收费的），如果需要使用其他可信时间戳服务器，请修改<code>timesign.sh</code>文件中的<code>TIMESTAMPSERVER</code>常量，并将<code>CAFILE</code>常量指向你使用的可信时间戳服务器证书（pem格式）。