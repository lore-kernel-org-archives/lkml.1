Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbYDUOEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbYDUOEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYDUOEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:04:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbYDUOEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:04:15 -0400
Date: Mon, 21 Apr 2008 16:04:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: x86: add mp_bus_not_pci bitmap to mpparse_32.c
Message-ID: <20080421140401.GP9554@elte.hu>
References: <200804181711.m3IHBSAk025658@hera.kernel.org> <20080418160054.4d6410a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418160054.4d6410a1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Apr 2008 17:11:28 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6333c3ccbdc0ae001cff6ee1d3633942ef763f4
> > Commit:     a6333c3ccbdc0ae001cff6ee1d3633942ef763f4
> > Parent:     8643f9d02a7bb9db74634b4c062d8e70ce7c59b9
> > Author:     Alexey Starikovskiy <astarikovskiy@suse.de>
> > AuthorDate: Thu Mar 20 14:54:09 2008 +0300
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu Apr 17 17:40:58 2008 +0200
> > 
> >     x86: add mp_bus_not_pci bitmap to mpparse_32.c
> >     
> >     Signed-off: Alexey Starikovskiy <astarikovskiy@suse.de>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Where are all these patches coming from?!?!?  Google does (or at least 
> did) index discuss@x86-64.org so I am out of ideas.

hm, they came in via private mail. I asked them to be Cc:-ed to lkml 
when i got them and the latest ones do appear to be so.

	Ingo
