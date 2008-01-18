Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYARKBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYARKBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYARKBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:01:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbYARKBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:01:14 -0500
Date: Fri, 18 Jan 2008 11:00:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] x86: MMCONF enable MCFG early
Message-ID: <20080118100044.GC30637@elte.hu>
References: <200801161405.17889.yinghai.lu@sun.com> <200801161406.38946.yinghai.lu@sun.com> <200801161409.02591.yinghai.lu@sun.com> <200801161626.19991.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801161626.19991.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> Ingo,
> it seems you removed
> > patch
> > 	x86: validate against ACPI motherboard resources
> last night. 
> 
> was it dropped?

yeah, i bounced it over to Greg - but Greg has not indicated it yet 
whether he has picked it up. Andrew has it in -rc8-mm1 at the moment.

	Ingo
