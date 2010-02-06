Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0BFGXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 01:23:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:43182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0BFGXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 01:23:22 -0500
Date: Fri, 5 Feb 2010 22:24:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
Message-ID: <20100205222430.1d17a72c@infradead.org>
In-Reply-To: <20100205154748.GA11469@infradead.org>
References: <20090925122556.2f8bd939@infradead.org>
	<20100205154748.GA11469@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 10:47:48 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Sep 25, 2009 at 12:25:56PM +0200, Arjan van de Ven wrote:
> > >From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00
> > >2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 25 Sep 2009 12:20:57 +0200
> > Subject: [PATCH] perf_core: provide a kernel-internal interface to
> > get to performance counters
> 
> So this patch got accepted into mainline a while ago, without a user
> ever beeing presented, nevermind actually included in mainline.  Time
> to revert providing these useless exports and dead code?
> 


Frederic had a user near mainline.

I have one but it's .35 material at this point...

if you want to insist to bounce the patch out now and back in
for .35... I don't care but Frederic might.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
