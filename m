Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXLLQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXLLQRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXLLQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:17:06 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:38603 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbXLLQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:17:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18272.2396.371368.928816@stoffel.org>
Date: Wed, 12 Dec 2007 11:16:28 -0500
From: "John Stoffel" <john@stoffel.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My results, PIII, Dual 550Mhz Xeon.

jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 775, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 774, in 332
jfsnew:~/src> sudo ./port80
cycles: out 775, in 335


jfsnew:~/src> cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 547.216
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1095.01
clflush size    : 32
