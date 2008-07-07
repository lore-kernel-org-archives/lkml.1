Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYGGHZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYGGHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYGGHZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:25:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYGGHZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:25:14 -0400
Date: Mon, 7 Jul 2008 09:24:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-ID: <20080707072438.GA8011@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.XLC.s0LcIB@albercik> <20080706111750.a6d77e81.randy.dunlap@oracle.com> <20080707064227.GA27622@elte.hu> <86802c440807070015qbfdbf08s62ce5c37092d0fb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807070015qbfdbf08s62ce5c37092d0fb5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sun, Jul 6, 2008 at 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> >> This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
> >
> > one thing i dont see you having followed up on is whether tip/master
> > works fine:
> >
> >  http://lkml.org/lkml/2008/6/11/355
> 
> in the response to me, he said tip/master has the same problem

ok, so an unfixed problem.

	Ingo
