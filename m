Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXFNVV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXFNVV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbXFNVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:21:00 -0400
Received: from smtp3.libero.it ([193.70.192.127]:54738 "EHLO smtp3.libero.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbXFNVU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:20:59 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 17:20:58 EDT
X-Scanned: with antispam and antivirus automated system at libero.it
Message-ID: <4671AF64.9050201@gmail.com>
Date: Thu, 14 Jun 2007 23:13:08 +0200
From: davide <davidenitti@gmail.com>
User-Agent: Mozilla Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Random X lockup
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a problem with X, I have random lockup of X, when happen i can't 
use mouse or keyboard.
Using a SSH remote session I can see that X taking 99.9% cpu.
I have this problem with all version of kernel, linux distributions, 
xorg versions.
Reading some forum, I can conclude:

- The crash occurs on various hardware
-- CPU: P4 3Ghz, AMD Athlon Thunderbird 1400, AMD Athlon 900Mhz, Athlon 
XP 1500+, Pentium III 866MHz
-- GFX cards: Radeon 9200, Radeon 9700, NVidia GeForce2 GTS/Pro, GeForce 
Ultra 5700, Geforce FX 5200
-- M/B: Abit AT7 (VIA KT333), SiS P4S61, (TODO add more mobos)
-- Mem: various sizes

- It occurs on various w/ms like: kde, gnome, ion2, fluxbox

- It occurs on various kernel versions: 2.4.23-ck1 - 2.6.21

- It occurs on various X versions:
--XFree 4.3 - ??
--Xorg up to 7.2

-Reports in various distributions: debian, mandrake, fedora, gentoo, 
ubuntu, opensuse

Sympthoms:

- X CPU usage 100%
- Keyboard is not working
- Mouse is working but nothing is clickable (in some cases mouse is not 
working any more)
- Magic SysRq is possible
- SSHing in from remote server and killing X is possible.

I can't solve this problem since years :-(
please help me!
Thanks

Davide Nitti
