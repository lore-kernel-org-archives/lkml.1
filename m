Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZJZKSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZJZKSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 06:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZJZKSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 06:18:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39336 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755493AbZJZKSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 06:18:38 -0400
Date: Mon, 26 Oct 2009 10:17:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: GeunSik Lim <leemgs1@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
 v2,headers to Dual BSD/GPL
Message-ID: <20091026101737.34697439@lxorguk.ukuu.org.uk>
In-Reply-To: <20091026073048.GC8162@elte.hu>
References: <20091023160257.GA30447@Krystal>
	<20091023160632.GA2198@Krystal>
	<alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
	<20091026015357.GA6033@localhost>
	<023001ca55e1$436e38e0$808410ac@zhaoleiwin>
	<49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
	<20091026073048.GC8162@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can  we re-distribute with dual license (e.g: bsd/gplv2 or lgpl
> > 2.1/gplv2)   about some source of linux kernel source? I think that
> > linux kernel source is GPLv2 only. Frankly speaking, I am not know
> > exactly about  legal issues of your questions.
> 
> Yes, the legality of such relicensing is questionable as that code was 
> never developed outside of the kernel but as part of the kernel.

We have lots of dual licensed code in the kernel. The copy in kernel may
well only act as GPLv2 but the copy outside has other licences (Linus for
example relicensed some of his early locking primitive/atomic bits for
the Mozilla folks)

> So for those two grounds i cannot give my permission for this 
> relicensing, sorry.

One comment here - and one to be careful of for relicensing purposes. In
most parts of the world if you were paid by an employer to produce the
code that the request relates to then the rights to it belong solely to
the employer. Permission (or refusal) from the code author may well be
meaningless because such permission must come from the employer and right
owner in question (so IBM, Red Hat etc) in those cases and not the author.

Alan

