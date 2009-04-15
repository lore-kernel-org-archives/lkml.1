Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZDOWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZDOWlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZDOWlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:41:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZDOWlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:41:01 -0400
Date: Thu, 16 Apr 2009 00:40:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415224017.GA18764@elte.hu>
References: <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009, Ingo Molnar wrote:
> > 
> > Impact line exposes wrong patch structure: cleanup should never be 
> > mixed with fix.
> >
> > impact line somewhat atypical but correct - the patch is a cleanup 
> > but might affect user-space.
> >
> > Impact line is correct.
> > 
> > Impact line is not duplicative of subject line.
> >
> > Impact line is incorrect (describes action not effect).
> > 
> > Impact line is correct and appropriate.
> 
> Bah. 
> 
> In _no_ case did the Impact: line actually say anything worth 
> saying, and it was there just for self-gratification.

As i said it in the mail, i actually used the impact line of commit 
6b44003e5ca66 ("work_on_cpu(): rewrite it to create a kernel thread 
on demand") later on, when a regression was caused by that commit.

It is the third entry above.

	Ingo
