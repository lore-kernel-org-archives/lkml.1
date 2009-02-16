Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbZBPPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbZBPPuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZBPPud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:50:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52967 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZBPPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:50:31 -0500
Date: Mon, 16 Feb 2009 16:50:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Manish Katiyar <mkatiyar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in
	kernel/kallsyms.c
Message-ID: <20090216155023.GA4422@elte.hu>
References: <ea11fea30902151034s5444efabw455c1dac1b875086@mail.gmail.com> <20090215184752.GA4970@uranus.ravnborg.org> <4999650C.6030700@s5r6.in-berlin.de> <20090216132822.GC17996@elte.hu> <4999717F.7090205@s5r6.in-berlin.de> <20090216141917.GA8981@elte.hu> <499984C1.6020004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499984C1.6020004@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ingo Molnar wrote:
> > We routinely mention Sparse, lockdep, Coverity, Coccinelle, kmemleak, 
> > ftrace, kmemcheck and other tools as well when it motives to fix a bug 
> > or uncleanliness. [...] It is absolutely fine to
> > mention checkpatch when it catches uncleanliness in code that already 
> > got merged. I dont understand your point.
> 
> I wrote "don't mention checkpatch" but I really meant "think about what
> the effect of the patch is and describe this".

Are you arguing that in all those other cases the tools should not be 
mentioned either? I dont think that position is tenable.

	Ingo
