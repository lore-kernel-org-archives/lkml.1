Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZLBAxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZLBAxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZLBAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:53:14 -0500
Received: from mail2.racsa.co.cr ([196.40.31.26]:38969 "EHLO
	barracuda6.racsa.co.cr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZLBAxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:53:13 -0500
X-ASG-Debug-ID: 1259715202-0eeb024d0000-xx1T2L
X-Barracuda-URL: http://172.16.1.15:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: osobosque@racsa.co.cr
Date: Tue, 01 Dec 2009 18:53:08 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
In-reply-to: <4B159EEA.6030503@zytor.com>
Message-id: <alpine.LNX.2.00.0912011757140.855@bruno>
References: <alpine.LNX.2.00.0911291057100.2912@bruno>
 <4B143AE8.5090608@us.ibm.com>
 <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain>
 <alpine.LNX.2.00.0912011428350.855@bruno>
 <alpine.LFD.2.00.0912012236120.24119@localhost.localdomain>
 <alpine.LNX.2.00.0912011550120.855@bruno> <4B159EEA.6030503@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Barracuda-Connect: UNKNOWN[172.16.7.14]
X-Barracuda-Start-Time: 1259715202
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at racsa.co.cr
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=4.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=6.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.16060
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 1 Dec 2009, H. Peter Anvin wrote:

> Note: the best thing you could do -- although it is a bit time consuming
> -- would be to do a "git bisect" between the last known working version
> (2.6.28) and first broken version (2.6.31).
>

Just to clarify, the last known working version is 2.6.30.6; the first known
bad version is 2.6.31.

Joseph

