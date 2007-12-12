Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbXLLFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbXLLFBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXLLFBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:01:04 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:40981
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXLLFBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:01:03 -0500
X-Authority-Analysis: v=1.0 c=1 a=wBmbAKlaRUVhvNefPqQA:9 a=q2OogTHqZyUkwDXIbmbUAxYohX4A:4 a=0JaJP7ZG1FgA:10
Subject: Re: [RFT] Port 0x80 I/O speed
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 23:06:59 -0600
Message-Id: <1197436019.21734.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cycles: out 1296, in 1243
cycles: out 1312, in 1245
cycles: out 1289, in 1239
cycles: out 1309, in 1245
cycles: out 1308, in 1244
cycles: out 1325, in 1239
cycles: out 1310, in 1245
cycles: out 1289, in 1239
cycles: out 1301, in 1252
cycles: out 1325, in 1249
cycles: out 1307, in 1249
cycles: out 1304, in 1247

AMD 64 X2 4600 + / 2 gig memory - running the 32 bit version of
2.6.24-rc5-git1

>From /proc/cpuinfo

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 43
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4600+
stepping        : 1
cpu MHz         : 2412.378
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
3dnowext 3d
now pni lahf_lm cmp_legacy ts fid vid ttp
bogomips        : 4827.69
clflush size    : 64



