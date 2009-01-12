Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbZALW4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbZALW4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761352AbZALWxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:53:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252AbZALWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:53:29 -0500
Date: Mon, 12 Jan 2009 23:52:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc
	cpumask_var_t's.
Message-ID: <20090112225256.GA18771@elte.hu>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com> <20090112222123.GB15294@elte.hu> <496BC4B1.1080002@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BC4B1.1080002@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Ingo - should I push these to tip/cpus4096 via the cpus4096-for-ingo 
> >> tree since that has the relevant changes to irq_desc?  Or by some other 
> >> means?
> > 
> > yes, please update cpus4096-for-ingo so that i can pull it from your tree.
> > 
> > 	Ingo
> 
> Ok, I will do that right now.  And then you'll pull and do these other things:
> 
> > this should all be a single patch, because the cpus4096 tree does not 
> > build on these arhitectures right now.
> 
> > in fact, i think i'll rebase the whole lineup (so no need to resend - i'll 
> > squash these fixes together), because this is how it looks like right now:
> 
> ???

yes.

	Ingo
