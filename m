Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbXEJIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbXEJIAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXEJIAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:00:05 -0400
Received: from web60013.mail.yahoo.com ([209.73.178.76]:49007 "HELO
	web60013.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752927AbXEJIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:00:04 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 04:00:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HvrFjaXJVDcFEYl7D3bG9TfV7+ja+JF14zuGtfG2V2I/fI08U9j2qu7DUfwg07KlPHxVUGVn1wYHYxewutpIqbreoeutcXHKHrWQGKq6/RX2S6VIcA4F5QWMFRIA88agppoVGTcfYSlZh9VMfQFW2kFkRjxEr1T4Q8LCp6oxbsE=;
X-YMail-OSG: CuRBqykVM1n3l4gGuVx9Kqmk2Ym751arWtHYBdPSlGtRnXU9QrZxmuvIE3kUlJVecALY0wtk748icRFfRnyX0jAf6yDQ1lzpRjpQDx5F4BQpfMW0hXqItYaP6i3CPoY-
Date: Thu, 10 May 2007 00:53:20 -0700 (PDT)
From: Charles Gagalac <charle97@yahoo.com>
Reply-To: charle97@yahoo.com
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
To: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       charle97@yahoo.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705092329260.16104@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <421462.15161.qm@web60013.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Is it possible to have more information? Like CPU,

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 3
model name	: Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping	: 4
cpu MHz		: 3000.000
cache size	: 1024 KB
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
cpuid level	: 3
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep
mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr
sse sse2 ss ht tm pbe constant_tsc pni monitor ds_cpl
cid xtpr
bogomips	: 5989.96
clflush size	: 64

> kernel 32/64, userspace 
> 32/64 ...?
kernel is 32 
userspace is 32

> Does the problem happens with some other publicly
> available software that 
> runs under wine, so that I can test it?
> 

i just installed the windows version of firefox
2.0.0.3 under wine and firefox also froze after a few
minutes of use.

also, wine version is wine-0.9.36.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
