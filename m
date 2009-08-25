Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZHYR4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZHYR4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHYR4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:56:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:60806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755492AbZHYR4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:56:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18OJiYpw5YOps2VkOlmmWyDOafcZLHNMY5RqKZTqv
	/81UavQnr+bXiX
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: raz ben yehuda <raziebe@gmail.com>, riel@redhat.com, mingo@elte.hu,
       peterz@infradead.org, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 19:56:33 +0200
Message-Id: <1251222993.7023.53.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:23 -0400, Christoph Lameter wrote:
> On Sun, 23 Aug 2009, Mike Galbraith wrote:
> 
> > The rest, I'll leave off replying to, we're kinda splitting hairs.  I
> > don't see a big generic benefit to OFFSCHED or ilk, others do.
> 
> No we are not splitting hairs. OFFSCHED takes the OS noise (interrupts,
> timers, RCU, cacheline stealing etc etc) out of certain processors. You
> cannot run an undisturbed piece of software on the OS right now.

I asked the questions I did out of pure curiosity, and that curiosity
has been satisfied.  It's not that I find it useless or whatnot (or that
my opinion matters to anyone but me;).  I personally find the concept of
injecting an RTOS into a general purpose OS with no isolation to be
alien.  Intriguing, but very very alien.

	-Mike

