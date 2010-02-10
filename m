Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab0BJH2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 02:28:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0BJH2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:28:31 -0500
Date: Wed, 10 Feb 2010 08:27:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting
 xstate - V2
Message-ID: <20100210072756.GD31351@elte.hu>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
 <20100210011232.71CA51C5@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210011232.71CA51C5@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > Patches are on top of the -tip/master tree. First patch in the series 
> > reverts the first version of the patch that went into the -tip tree.
> 
> AFAIK tip/x86/ptrace is just a temporary branch containing nothing but your 
> patch.  So I imagine you don't need a reversion, Ingo et al will just put 
> the new patches on a fresh replacement branch.

Yeah - and the patches your review strikes we'll remove/fix as well. And you 
can pick up the patches yourself as well into your tree, if you wish to. (or 
pull it from us if we are done) We can push it too with your acks - your 
call.

> I'll reply to each patch individually.

Thanks!

	Ingo
