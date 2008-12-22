Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYLVHJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYLVHJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYLVHJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:09:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYLVHJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:09:09 -0500
Date: Mon, 22 Dec 2008 08:08:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: 2.6.28-rc9-git1: Reported regressions from 2.6.27
Message-ID: <20081222070840.GA12115@elte.hu>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <84144f020812210107k4be14431s4fb61f2d31da8621@mail.gmail.com> <200812212056.02246.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812212056.02246.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Sunday, 21 of December 2008, Pekka Enberg wrote:
> > On Sat, Dec 20, 2008 at 11:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12156
> > > Subject         : v2.6.28-rc2: x86_32 relocation regression?
> > > Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> > > Date            : 2008-11-24 21:19 (27 days old)
> > > References      : http://marc.info/?l=linux-kernel&m=122756158220966&w=4
> > 
> > I think this one has a fix in x86.git:
> > 
> > http://lkml.org/lkml/2008/12/18/224
> 
> I've dropped it from the list at the Ingo's request.

thanks Rafael!

	Ingo
