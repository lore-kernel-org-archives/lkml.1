Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0BJS62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:58:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab0BJS61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:58:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting
 xstate - V2
In-Reply-To: Ingo Molnar's message of  Wednesday, 10 February 2010 08:27:56 +0100 <20100210072756.GD31351@elte.hu>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100210011232.71CA51C5@magilla.sf.frob.com>
	<20100210072756.GD31351@elte.hu>
X-Windows: never had it, never will.
Message-Id: <20100210185815.4B4F9CC@magilla.sf.frob.com>
Date: Wed, 10 Feb 2010 10:58:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah - and the patches your review strikes we'll remove/fix as well. And you 
> can pick up the patches yourself as well into your tree, if you wish to. (or 
> pull it from us if we are done) We can push it too with your acks - your 
> call.

AFAIK there is no tree of mine that anyone habitually pulls from as part of
a regular merge procedure.  Since the x86 patches have to go through your
approval, and these ones are coming from someone else's postings (Suresh),
I'm not sure how I would or should fit into the chain.  If you would like
me to use a git branch for x86 things (ptrace things?  x86 ptrace things?)
that have my ACK and I think should be merged, I'm glad to do that.


Thanks,
Roland
