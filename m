Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbYJJL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbYJJL5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYJJL5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:57:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbYJJL5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:57:12 -0400
Date: Fri, 10 Oct 2008 13:56:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Message-ID: <20081010115655.GC19487@elte.hu>
References: <20081010002203.GA23238@linux-os.sc.intel.com> <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com> <20081010090100.GC319@elte.hu> <aa79d98a0810100416q72ec10d5q7d841e02dc4d4f81@mail.gmail.com> <alpine.LFD.1.10.0810101221580.19747@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810101221580.19747@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Fri, 10 Oct 2008, Cyrill Gorcunov wrote:
> 
> > Btw I don't remember but hope it was not me who made this typo --
> 
>  What would be the difference so that you hope it wasn't you?  All the 
> people make mistakes, this one has been caught and that's what really 
> matters.

yeah, like most kernel newbies Cyrill is worrying way too much about 
mistakes. In 10 years time he too will have his healthy collection of 
embarrassing brown paperbag incidents and will be a lot more relaxed 
about it, just like the rest of us ;-)

what matters is to fix them quickly and to learn from those mistakes 
that are avoidable.

	Ingo
