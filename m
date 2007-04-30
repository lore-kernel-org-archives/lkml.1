Return-Path: <linux-kernel-owner+w=401wt.eu-S1946821AbXD3Upo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946821AbXD3Upo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946818AbXD3Upn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:45:43 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57048 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946814AbXD3UpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:45:25 -0400
Subject: Re: 3d smoothness (was: Re: [patch] CFS scheduler, -v6)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070430201750.GA30752@elte.hu>
References: <1177809512.9756.10.camel@localhost>
	 <20070429170908.GA31417@elte.hu> <20070429173902.GA4349@elte.hu>
	 <200704301945.34082.lkml@metanurb.dk>  <20070430201750.GA30752@elte.hu>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 22:44:56 +0200
Message-Id: <1177965896.9863.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 22:17 +0200, Ingo Molnar wrote:
> * Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > This patch makes things much worse, [...]
> 
> yeah, the small patch i sent to you in private mail was indeed buggy,
> please disregard it.
It also hardlocked my box :) but it was worth a shot.
> 
> 	Ingo
> 

