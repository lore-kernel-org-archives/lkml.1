Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYKJIRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYKJIRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYKJIRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:17:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYKJIRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:17:41 -0500
Date: Mon, 10 Nov 2008 09:17:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: apic - use pr_ macros for logging
Message-ID: <20081110081732.GB17498@elte.hu>
References: <20081109105709.222708517@gmail.com>> <4916c290.0c07560a.4a14.ffffdde9@mx.google.com> <alpine.LFD.1.10.0811091239360.25325@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0811091239360.25325@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:
> 
> > Impact: cleanup
> > 
> > It saves us some sourcse lines and shift
> > the code a bit righter.
> > 
> > And a multiline comment style is fixed too :-)
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> >  arch/x86/kernel/apic.c |  116 ++++++++++++++++++++++---------------------------
> >  1 file changed, 53 insertions(+), 63 deletions(-)
> 
> Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
> 
>  Thanks, Cyrill -- it was high time to get this done.  And, BTW, at 
> the next opportunity please fix up your date -- I think it may 
> confuse some people and/or scripts.  Good to know it was a Thursday 
> though. ;)

applied	to tip/x86/apic, thanks guys!

	Ingo
