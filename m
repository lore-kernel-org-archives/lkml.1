Return-Path: <linux-kernel-owner+w=401wt.eu-S1765702AbYA3VYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765702AbYA3VYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933528AbYA3VVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:21:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512AbYA3VVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:21:10 -0500
Date: Wed, 30 Jan 2008 22:20:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mike Travis <travis@sgi.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ia64@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080130212030.GA12269@elte.hu>
References: <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu> <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com> <20080130200221.GA28073@elte.hu> <1FE6DD409037234FAB833C420AA843EC757FC2@orsmsx424.amr.corp.intel.com> <20080130205915.GA4562@elte.hu> <1FE6DD409037234FAB833C420AA843EC758076@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC758076@orsmsx424.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> I'll start digging on why this doesn't boot ... but you might as well 
> send the fixes so far upstream to Linus so that the SMP fix is 
> available (which is all anyone really cares about ... there are very, 
> very few UP ia64 systems in existence).
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

thanks alot! Can i also add your Acked-by to this patch:

  Subject: ia64: use generic percpu
  From: travis@sgi.com

it seems like a sensible cleanup to me.

	Ingo
