Return-Path: <linux-kernel-owner+w=401wt.eu-S965377AbXAYGMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377AbXAYGMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXAYGMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:12:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965377AbXAYGMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:12:15 -0500
Date: Thu, 25 Jan 2007 07:10:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070125061053.GA27335@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com> <20070124070701.GA17654@elte.hu> <1169631016.19471.175.camel@imap.mvista.com> <1169668653.6905.49.camel@localhost.localdomain> <1169671890.19471.309.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169671890.19471.309.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4795]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Only in so much as the high res changes parallel my own. That includes 
> from my set the update_callback removal and the rating sorted list. 
> thats about where the similarity stops, even those changes don't 
> appear to have the breath of mine.

because they were done totally independently, in the timeframe of about 
15 minutes. Really, this is much ado about nothing.

	Ingo
