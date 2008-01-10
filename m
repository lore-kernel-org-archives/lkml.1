Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYAJEhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYAJEhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 23:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYAJEhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 23:37:05 -0500
Received: from ip-163-246-113-216.pool.grokthis.net ([216.113.246.163]:2700
	"EHLO mail.mhcomputing.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014AbYAJEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 23:37:04 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 23:37:03 EST
Date: Thu, 10 Jan 2008 04:27:59 +0000
From: Matthew Hall <mhall@mhcomputing.net>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
Message-ID: <20080110042759.GA9755@mhcomputing.net>
References: <20080110024733.GC9461@mhcomputing.net> <20080110033944.GW16309@parisc-linux.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20080110033944.GW16309@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Matthew,

On Wed, Jan 09, 2008 at 08:39:45PM -0700, Matthew Wilcox wrote:
> On Thu, Jan 10, 2008 at 02:47:33AM +0000, Matthew Hall wrote:
> > I am using the Supermicro H8DCE motherboard. Some (not all) of the SATA 
> > channels quit working due to some kind of resource conflict when I 
> > upgrade to any kernel above 2.6.20.xx series, in my case I am running 
> > 2.6.20.21 SMP x86_64 presently.
> 
> Could you provide an 'lspci -v' and a 'cat /proc/iomem' for both kernels
> please?

I attached the requested materials to this mail.

> This doesn't seem to be a scsi problem per se, so I'm adding
> linux-kernel and linux-ide -- can you drop linux-scsi from any reply
> please.

Sorry, my mistake... since SATA was located under the SCSI section of 
the kernel and I have not posted previously I was not sure where to go 
with this one.

--jI8keyz6grp/JLjh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="iomem-2.6.20.21.gz"
Content-Transfer-Encoding: base64

H4sICLCZhUcAA2lvbWVtLTIuNi4yMC4yMQB1lMtu2zAQRff6CgJdu6Ds2FK9c7wojDSJkQTZ
FEXAx0xs1LUKSTXavy855Egyywo2IOnceznDh6QM18z9P6FGFGvx/Kfr4Yd42twXQsiJgC4n
2LaqO4jv0J7hVJDRcAJSQgsdtBewHip26whfjxYany5UC8pLDEsM2Knk8Z4oRmplRXRj1c8e
WubIbowDcP2Ey1C9q8wkOLY35/aWtZG1b++OGhOmsUAKAqVTrLBUgKPCql4VLtnyENaGITbb
/U68KH2CjjhEzhUSf2jOs0tzUv3xBOK5b1r1DoXi6Vaj+vPm6aXQCx2ArjSD/XYnbn914oMs
XaF6Ga16OVj981qWayk/Si9ZsWT1P0ledL4c7VH5hEpDWsZVgq5MdGOmzoWP0JyvkyIWLoWL
yIjM77r+Kr/5CMPU5CLKEJERTSIsU5uLmIeIjGgSAUwhF3FTaDRxsuhmInC/OZWZk8DBHN8O
xno/6ghpNq/9Mvj/kTRTv2FoEv/N4E8lD69+scX2rpbUA+1vEtgkox4yUknnjsbb+UJ2YAaJ
XQ32VIJN674F0B8oAJliElANAalkHD8s4cyO7PrYGD5xBpNVjDvauqJMiACeot3jZr/bCu/P
YfLXMmxn/96ywCaCMIM5CXfgXwEzSOzVYE8lUzsyw8SuBnsqGRcAIR5ourlq35tzePj8IwBD
YPilMeokvL9ArOqAx6kfvKXkhSmXI558vP8C7dbLS7sGAAA=

--jI8keyz6grp/JLjh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="iomem-2.6.23.12.gz"
Content-Transfer-Encoding: base64

H4sICF6dhUcAA2lvbWVtLTIuNi4yMy4xMgB1lV1vmzAUhu/5FZZ2ncmEBrPcZVxUUbcuaqvd
VFPlj+MlKoMKWLT9+/mDg8H1okQiet738Yn5CKX+tTGfT1poTfbk8e8wwi/ycPiaEUIXAfcy
gbrnw5m8Qt9Ck7miRIN2hh4G6K+gLJTYVhN8a9+MdU8dhXKi+n019wsbqZxgNNkWJ9sB2xal
Cdy5mYjsFLiEA8wkWCmU1CGh+MgzY1a4hFJ+iUN9OpInLhoYHIeJ43yO33ft5to1fLw0QB7H
ruc/IeO4Uzykbw8PT5kohAeCCQSn+kg+/x7IB5qbQcVuqordXLXf9zTfU/qR2kiJkfJ/kXSo
vV7UhVsDExCPsTIIJqe2TsxZWIVAv4iGKIwFh0iE5J+qeqY/rEIilSlF7hWJ0EKhkKqUYusV
idBCAUghpbjJhJbTZrmDRcC8t27MVATO8vJylsr2tZig2811n/r+u0i37EuEMurfzP04cv/d
nmxS31XU/QZ3fbuAihzV7Igjg7k1XtqrqwMyiOp8rscR3fUSFIxnJ9BIdSRgsyCOhPX9Kdyo
wNa3jcQ7TuroLE5XtDJDSa8A3KLjt8PpWBPbT2HXr2i4nFMhfIQxt4JCqiKF3+N1pEgIAClE
AjYLQiQl0Eh1JOCzII6E0wS4ixB2EfUy0zA9FNzBagutOoXnR7gGQAgIv3SSN8T2M61Z5XFY
eO7mFMfKdwEv/gD+AUZ+SV26BgAA

--jI8keyz6grp/JLjh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="lspci-verbose-2.6.20.21.gz"
Content-Transfer-Encoding: base64

H4sICKCZhUcAA2xzcGNpLXZlcmJvc2UtMi42LjIwLjIxAN1ZW2/iOBh9Lr/Cb9uRyta5EEy1
XYkCA6jKwpZOtRLiwXEcam1IoiQww/z6tZNAk0BC2DL0khcS+fqd813sA4Q3EP4OgU4Xrr8G
xHVC37Vt6t8A54mZDIOO63uuj0PmOqBzj6C66dvZ9gWXPl0BrHypXUyWRrAOQrq4AZOlx5t0
RnyX9114y5B/Dh0Cvjn/Ou53B5h0xQgFEpSk2sVXG8+DG2AsA7DAfAL/CmiaPvh5BSz+KfoG
1L4CNg6pQ9YA1i462MMGs1nIKB/4ByaEBgHv6DBq/lmrQW6ZxC0bTtrA8Jk5pyUmiU53Uac3
sSXZrAQm+t0yKNln1J5sUT7BFne3VbsYXo8AXzYMAA6BSggE04D9pLeKPNtphJtGTd1tVDON
FeiSOV3fJncpzyqBIttxiwm49Hx3XmcWNxRMR4POcHZOKq/A8OFvIPORSZRwJAyLWAbkUF0q
ct1g4RVwXKfu+dSiIXnGhk2/JECp91WBkl4JlJICSuZA9d4IKDkHFIWVgJIbWjWkVJHblnbI
FlSgg5cmc6tluXbnt1YTtKMBe/zs/FDBXIBhuI2+GI5MawvlWrP+SE7qj5rIs90eYA63xsKk
NNXyfhGIVjpYEQZTPQIDTCgZg7HPxqfwx30JbrpifrjE9gy8YCLcDkpWOSYmC8SbOUvgQbOS
yRQxWbj2KFAqTSaVTSY1T7mz5vE7y/iWEnneTreKIdk8wlkm1GfYBu3H9k4MWukUhhpp9xkJ
9xm9Ud7PIEVeKiTKo0heInSnePLaWTwOFo8zXtaTdoPeOmnQo0/MYz7XGiV8GCV84BL+cQn/
WC3j0Twpjy3O47gzPHxIFp0yh+R0AocSmHKWQh+TkK0oX4K4JhXcHX+yj87Ans8W2F/fQs5J
wCdzzOiLp6xgabi+yRw+IP6mpJ6MvpVktEXLoM/MMbd2GU0Spb+6YRmWeGLzMTf/7pDpvfCZ
+g4N3/jSU3Bosmh1h8i6Lsq4ZwVnMY9wll7+SpXyFr7sX66/4Dmh1FH+j4fIOQ+Rsx5S7eZI
37+dUs5OacdOwXUuCEQAIBEE0YsIgqJoUYwkWppJtFyMUz4FFntHweQxohyVLCMeU5SfaJbD
4Euisgxcjshm2ra5wg6hZhJY3SiGAjBt690ZuEf8JXy2XUdTr0cex9N1ZmDAzzf+o4+dQHg7
eKTk2XFtdx7pFhabL2MWt2xkToiV9ii9eo9t0/TFxDr29u4jWUh+9ULdh7aeSl1liymvXkxn
AaG2jR3qcg9PVi1esvUByG6di+zWOclunZlsKZYan/ptfgNfeJwSkUgOXMb7/LIy7dOvrs+r
ZlPjCbX/OEsyrZTLtPHMm+ly58Y+m+O6sQ5p2j1yVVlRpeYR+Tkux1IrU461OOEdLseSpmdO
dgRuRmpqPLJA+cgOMxr5YeULZg4AKHVfkLOXxt4Pj8eToOBhpEcLNY1Yndm9+cmoyllTiQXZ
lByzYibNyjHcg+gP7PCD1j+yghC8lq7layUqxU9RZ8yrTSzKdKOCmpzDYCPLtkcG3cenzc+g
W29wmPZSK3ayXOyQq6l72TWOY7cSJFIakleCMY0/x5zg2XmRIb8AGfmUyOjjXv8tgDF/ATDq
KYEZPpwHFpiBhZ4UFvRp/8dCyf9YH9CyF7ZNix4hOUc2f2KZUNVyZdhCxTKRpRbLRBYsHkdJ
8TiKiuQlQdQRakIF3/3EMqHayONaIhPSEpnQLJEJzRKZ0CyUCQWPp5MJ0YfUydRmHpEjBPBs
nJFjdDL0TnUylNGPUE4nQ0frZOid6mQ5O3M6GdrVyQ7Y+R+Wc7xHJCMAAA==

--jI8keyz6grp/JLjh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="lspci-verbose-2.6.23.12.gz"
Content-Transfer-Encoding: base64

H4sICFGdhUcAA2xzcGNpLXZlcmJvc2UtMi42LjIzLjEyAN1ZXW/iOBR9Lr/Cb9uRytb5IJhq
uxIFpqCKhS2daiXEg+M41NqQRE5ghvn1ayeBJoGEsGXodPJCIn/ec+69vj5AeAPh7xAM6cLj
a0A8N+Se41B+A9xnZjEMOh73PY5D5rmg84Cgvunb2fYFl5yuANY+1S4mSzNYByFd3IDJ0hdN
Q0a4J/ou/GUoPgcuAV/cf13vqwssumKEAgUqSu3is4PnwQ0wlwFYYDEBvwKGMex/vwK2+JR9
A+pcAQeH1CVrAGsXHexjkzksZFQM/AMTQoNAdHQZtf6s1aCwTBGWDSZtYHJmzWmJSbLTXdTp
XWxJNquAyfBuGZTsM2pPtqieYIu726pdDK5HQCwbBgCHQCcEgmnAvtNbTZ3tNMJNo6HvNuqZ
xgp0qYKuL5O7lGeVQJHtuMUEXPrcm9eZLQwF01G/M5idk8orMHj8G6hiZBIlAgnTJrYJBVSX
mlo3WXgFXM+t+5zaNCQv2HTopwQo/aEqUMobgdJSQKkCqN47AaXmgKKwElBqw6iGlC5z29IJ
2YJKdPDSYl61LNfu/NZqgnY0YI+fnR8qmAswDLfRF8ORaW2hXGvWH8lJ/dGQebbbA8wV1tiY
lKZa0S8C0U4HK8JgOozAABNKxmDM2fgU/rgvwU1XjIdL7MzAKybS7aBil2NisUC+WbMEHjQr
mUyTk4VrnwKt0mRK2WRK85Q7ax6/s4xvaZHn7XSrGJLNI5xlQjnDDmg/tXdi0E6nMNRIu89I
us/onfJ+BinyekKiPIrkNUJ3Dk9xdhaPg8XjzNf1lN2gt08a9OgX5jGfa80SPswSPnAJ/7iE
f6yX8WidlMeW4HHcGRwukmWnTJGcTuBQAVPBUsgxCdmKiiWIZ1HJ3fGVfVQD+5wtMF/fQsFJ
ICZzrehLpKxgaXrcYq4YEH9TUk9G3yoq2qJl0hfmWlu7zCaJ0l/dtE1bPrH5WJh/d8j0XvhC
uUvDd770FBRNNq3uEFnXRRn3rOAs1hHO0stfqVLeIpb9y+MLkRNKHeX/eIia8xA16yHVbo70
57dTydmp7Ngpuc4FgQwAJIMgepFBUBQtmplESzOJlotxyqfAYu8omDxmlKOSZeRjyeMnmuUw
+Io8WfqeQGQzbdtaYZdQKwmsbhRDAZi2h90ZeEDiJXxxPNfQr0e+wNNzZ6Av6hv+xLEbSG8H
T5S8uJ7jzSPdwmbzZczilo1MhVhpj8qb99i2LC4nHmJ/7z6ShdQ3L9R9bA9TqatsMe3Niw1Z
QKjjYJd6wsOTVYuXbH0AslvnIrt1TrJbZyZbiaXG5/u2uIEvfEGJTCQHLuP34rIyvaefPS5O
zaYhEur90yzJtEou08Yzb6bL1Y33bI7r5jqkaffIncqarjSPyM/xcay0MsexESe8w8exYgwz
lR2Bm5GGHo8sUD6yw8xGflj5gpkCAKXuC6osAXrffBFFEvjH0TCavmnGmszufU9FVSpMLZZh
UyLMilk0K8IIv6HfsCvKq39UDSF4rVyr11p0AD9HnbE4Y2Ipphsdo0n1BRtZjn3S7z49b376
3XpDgLOXULmT5WKHUkPfy6l5HKeVIFHSkLwRjGn8ORa0zs6LDPkByKinRGY47t2/BzDWDwBG
PyUwg8fzwAIzsNCTwoJ+2X+vUPLv1Qe07JVty6ZHCM2RzR9JHNyHg3R53cidsjYqVoFsvVgF
smHxOEqKx1FUpB5JRo4QCyo46UdSAQsJa+QBLJH7aIncZ5XIfVaJ3GcVyn2SsNPJfehD6l16
M4/IEUJ2NqDIMXoX+kn1LpTRgVBO70JH613oJ9W7cnbm9C60q3cdsPM/pTntXewiAAA=

--jI8keyz6grp/JLjh--
