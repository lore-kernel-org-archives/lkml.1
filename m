Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZGCQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZGCQeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZGCQeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:34:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbZGCQeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:34:09 -0400
Date: Fri, 3 Jul 2009 18:33:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703163358.GA19685@elte.hu>
References: <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk> <20090703144754.GA13246@elte.hu> <20090703160230.093e422c@lxorguk.ukuu.org.uk> <20090703155809.GA20121@elte.hu> <20090703172651.619162fd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703172651.619162fd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Ingo, if you've nothing better to do than quote out of context 
> > > and be offensive, perhaps you should go fix voyager support or 
> > > something productive instead.
> > >
> > Another question: i'm wondering why you brought up Voyager 
> > support here. Are you trying to insult me?
> 
> [and]
> 
> > Pointing out when your code is unclean does not count as an 
> > offense on lkml, i hope
> 
> Nor then I trust does pointing out that voyager needs a bit of 
> work ;)

Voyager is not upstream anymore so i dont understand your point ...

I do think the Voyager code needs a lot of work, and i reviewed the 
patches that were submitted. I'm aware of no Voyager patch series 
that i find acceptable, and the things i noticed so far already mean 
quite a bit of work.

	Ingo
