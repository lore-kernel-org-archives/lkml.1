Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXHJHGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXHJHGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbXHJHGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:06:19 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:38334 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756648AbXHJHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:06:17 -0400
Message-ID: <46BC0E5B.6030403@interia.pl>
Date: Fri, 10 Aug 2007 09:06:03 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708071750.51019.jimis@gmx.net> <46BA14A2.5030705@interia.pl> <200708091117.51687.jimis@gmx.net>
In-Reply-To: <200708091117.51687.jimis@gmx.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 338daacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So I would assume that delay_tsc() probably only makes the situation worse for 
> the libata tests, but the real problem is at __switch_to() and schedule(). Do 
> you agree with these assumptions?
Yes. I agree that percentage of CPU time is unreasonably high for these 
functions. But not only for them.
> Is there a way to for oprofile to report the time spent in function calls 
> depending on the call trace?
I don't know any.
> Thanks again for the help. I guess if that doesn't lead anywhere I'll just 
> start compiling older vanilla kernels and see when the problem dissapears. 
> But this needs a lot of time and I'm not sure for how long I'll be able to 
> not offer any service with those disks (I was supposed to use RAID 0 to 
> provide storage space with them, but with the current problems that wouldn't 
> be so wise).
Probably this is the best and fastest way to diagnose problem.
> Dimitris
Regards
Rafa³


----------------------------------------------------------------------
Ta¶m Renaty i Andrzeja tu nie znajdziesz.
Mamy co¶ lepszego ... 

>>>http://link.interia.pl/f1b41


