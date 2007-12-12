Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbXLLQji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbXLLQji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbXLLQjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:39:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:59715 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbXLLQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:39:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XLNnuXz9ZtR1KdWPoNtRonMRoArXdlPsimaAep+dK0pvTl+FqHBnmA1iQ2zcHCrntPV/6yjX+QOVdCy5HT20bUIvPdKNlDYcXA0UiIZ0aAYKdRb8WySTvj/UxLGa6Wr6Wx+dgHux3/E7CqUgApqVIZ/An0g/0Z1mR9YQdZt/DFQ=
Message-ID: <6101e8c40712120839w2de15f96m6e6ee87980a07c3@mail.gmail.com>
Date: Wed, 12 Dec 2007 17:39:22 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: [RFT] Port 0x80 I/O speed
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, "Krzysztof Halasa" <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475F1DC6.5090403@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pancs:/tmp# for((i=0;i<20;i++)); do ./port80; done
cycles: out 4098, in 2532
cycles: out 3951, in 2389
cycles: out 4043, in 2485
cycles: out 4058, in 2393
cycles: out 4056, in 2509
cycles: out 4063, in 2394
cycles: out 4076, in 2508
cycles: out 4143, in 2395
cycles: out 4062, in 2502
cycles: out 4084, in 2383
cycles: out 4055, in 2510
cycles: out 4228, in 2410
cycles: out 4071, in 2508
cycles: out 4062, in 2502
cycles: out 3982, in 2398
cycles: out 4103, in 2391
cycles: out 4160, in 2404
cycles: out 4010, in 2462
cycles: out 4105, in 2449
cycles: out 4028, in 2477

---------

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping	: 9
cpu MHz		: 3150.045
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips	: 6303.37
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping	: 9
cpu MHz		: 3150.045
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips	: 6300.14
clflush size	: 64
