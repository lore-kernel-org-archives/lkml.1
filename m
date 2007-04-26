Return-Path: <linux-kernel-owner+w=401wt.eu-S1031077AbXDZOdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031077AbXDZOdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031141AbXDZOdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:33:21 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:44259 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031077AbXDZOdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:33:20 -0400
X-Greylist: delayed 1482 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 10:33:20 EDT
Subject: Re: [patch] CFS scheduler, -v6
From: Redeeman <redeeman@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070425214704.GA32572@elte.hu>
References: <20070425214704.GA32572@elte.hu>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 16:06:39 +0200
Message-Id: <1177596399.14496.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 23:47 +0200, Ingo Molnar wrote:
<snip>
> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome,

well, from my experiences with cfs on workstation/desktop, on amd64
2ghz, cfs doesent measure up to SD at all.

audio skips easily, with or without reniced X, and games are not as
smooth. also it seems to be much lower throughput. vanilla seems much
better by comparisin.
> 
> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

