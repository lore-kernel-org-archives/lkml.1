Return-Path: <linux-kernel-owner+w=401wt.eu-S1751577AbXAZVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbXAZVBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXAZVBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:01:20 -0500
Received: from main.gmane.org ([80.91.229.2]:59568 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXAZVBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:01:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: [x86-64, CMOS/RTC] Re: 2.6.19.2: bad reads/writes from/to CMOS clock
Date: Fri, 26 Jan 2007 21:01:01 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerkrgn.ae0.olecom@flower.upol.cz>
References: <9e18e56a85195bf4a507163df8e2f62e@teksavvy.com>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

26-01-2007:
> I am running 2.6.19.2 kernel from kernel.org.

2.6.18 debian, didn't see before, but maybe it was just big uptime ;)

> This is my first SMP kernel. 
>
> The problem I describe below has not happend with non-SMP kernels ever...
>
> I have installed my new AMD64 x2 4800 CPU just a few days ago. My mobo is Asus A8N SLI
> (Nvidia chipset).

UP ASUS A4K x86-64 CPU Mobile Athlon 64 3200+

> My problem with this new setup is that my CMOS clock is thrown off by varying 
> amounts of time. I have seen system times as long as ten months into future, and as
> long as 25 days in the past. At the moment my system clock has correct 
> hh:mm:ss, but it shows the date Jan 1st, instead of correct 25th.

I saw bad CMOS read, but CMOS itself was OK, after checking it with
hwclock or reboot by magic IRQ.

[]
> I would appreciate any ideas on how to follow-up on this problem. 
>
> I am eager to try things, collect data as needed. Just tell me what to do.
>
> Thanks in advance.

> Yavuz Onder

I don't know, because it was month or so ago. And i'm usual for bugs
(or curved hands ;).
____

