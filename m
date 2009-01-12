Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZALTN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZALTN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZALTNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:13:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45285 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZALTNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:13:46 -0500
Date: Mon, 12 Jan 2009 20:13:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: xen: fix too early kmalloc call
Message-ID: <20090112191332.GC15494@elte.hu>
References: <496A4C8F.8070005@sgi.com> <20090112085302.GB21976@elte.hu> <496B89F4.7080406@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B89F4.7080406@sgi.com>
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

> > i've applied the fix to tip/cpus4096, in the form below.
> > 
> > Please submit clean log messages. Your commit description was confused 
> > - the patch is From: Christophe, but the message talks about 
> > Christophe in the third person. Also, it included conversational bits 
> > that have no value for the Git history.
> > 
> > 	Ingo
> 
> Ahh, ok, will do.  I wasn't sure how many "liberties" we can take in 
> submitting/changing something from someone else.

You are free to perfect anyone's commit log in essence - i do it for 90% 
of all commits that go via -tip. I fix tyops and grammar mistaiks in every 
second commit, and have to fix basic formatting, structure, explanations 
and reported-by credits and tags in most of them. Submitting patches with 
a well-structured commit log gives you extra credit :-)

[ Obviously you are not free to make a commit log worse and then make it 
  appear as if the guy who submitted it did it ;-) ]

	Ingo
