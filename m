Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0BKDqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 22:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0BKDqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 22:46:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting
 xstate - V2
In-Reply-To: H. Peter Anvin's message of  Wednesday, 10 February 2010 18:18:07 -0800 <4B7368DF.60907@zytor.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100210011232.71CA51C5@magilla.sf.frob.com>
	<20100210072756.GD31351@elte.hu>
	<20100210185815.4B4F9CC@magilla.sf.frob.com>
	<4B7368DF.60907@zytor.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100211034553.A657CD14@magilla.sf.frob.com>
Date: Wed, 10 Feb 2010 19:45:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We're happy to carry the patches as long as it's okay with you.  We were
> mostly wondering if you preferred any other kind of workflow.

When I write patches myself, I always use git, so it is always easy and
most convenient for me to have my own branches pulled directly just to
save on 'git rebase' churn later.

As to a regular workflow of using a well-known branch of mine, I think it
makes sense for me to maintain a branch if there is an area where things
are presumptively merged just on my approval and I'm the one who has to be
lobbied to revert them.  I have not heretofore acquired the sensation that
this was the case with any given area of code.


Thanks,
Roland
