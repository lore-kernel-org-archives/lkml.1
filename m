Return-Path: <linux-kernel-owner+w=401wt.eu-S965543AbXAYGeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543AbXAYGeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965549AbXAYGeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:34:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965543AbXAYGeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:34:11 -0500
Date: Thu, 25 Jan 2007 07:32:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@mvista.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070125063206.GA26764@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com> <20070124070701.GA17654@elte.hu> <1169631016.19471.175.camel@imap.mvista.com> <1169668653.6905.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169668653.6905.49.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3240]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> Although, to be fair, I do know that Daniel has future sched_clock 
> related patches that need his cleanups [...]

btw., i dont find those sched_clock() changes really acceptable in their 
present form, and i've pointed out my reasons for that in the past, ~2 
months ago when Daniel last sent his cleanup queue.

	Ingo
