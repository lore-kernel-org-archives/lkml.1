Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZAaN3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZAaN3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 08:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZAaN2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 08:28:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZAaN2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 08:28:51 -0500
Date: Sat, 31 Jan 2009 14:28:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
Message-ID: <20090131132828.GA17271@elte.hu>
References: <49833350.1020809@kernel.org> <4983E5D3.3040100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4983E5D3.3040100@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, again.
> 
> Please disregard the previous two rebased trees.  There has been a
> major communication misunderstanding between Ingo and me leading to
> the rebased branches.  Here is yet another, hopefully final, merged
> tree which builds on top of tip/core/percpu and took only about ten
> minutes as opposed to hours.  :-)
> 
> * Three xen fix related patches merged.  Later threes conflicted in
>   non-minor way.  Requested refresh.
> 
> * Cliff Wickman's UV flush fix patch revived and merged.
> 
> * Pull in linus#master[1].
> 
> Anyways, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> The commit ID should be da2c0b021cde94866f1e492f940aad29e8f61258.
> 
> Sorry about the mess but this one should be the safe one to post
> patches against.

Very nice - pulled into tip/core/percpu, thanks Tejun!

	Ingo
