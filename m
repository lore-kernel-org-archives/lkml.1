Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0BJBNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:13:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0BJBNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:13:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting xstate - V2
In-Reply-To: Suresh Siddha's message of  Tuesday, 9 February 2010 12:13:09 -0800 <20100209201309.902050211@sbs-t61.sc.intel.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
X-Windows: the problem for your problem.
Message-Id: <20100210011232.71CA51C5@magilla.sf.frob.com>
Date: Tue,  9 Feb 2010 17:12:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patches are on top of the -tip/master tree.
> First patch in the series reverts the first version of the patch that went into
> the -tip tree.

AFAIK tip/x86/ptrace is just a temporary branch containing nothing but your
patch.  So I imagine you don't need a reversion, Ingo et al will just put
the new patches on a fresh replacement branch.

I'll reply to each patch individually.


Thanks,
Roland
