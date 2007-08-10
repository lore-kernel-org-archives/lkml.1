Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXHJIth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXHJIth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759728AbXHJIs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:48:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbXHJIsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:48:53 -0400
Date: Fri, 10 Aug 2007 10:48:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>, tglx <tglx@linutronix.de>,
       torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after
	random time
Message-ID: <20070810084841.GA11086@elte.hu>
References: <JMJTMH$F1699B57C9B0E170ED337488612E649B@xandmail.com> <20070810083720.GE1764@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810083720.GE1764@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> On Fri, Aug 10, 2007 at 10:15:53AM +0200, Jean-Baptiste Vignaud wrote:
> ...
> > I was still testing on -rc2:
> > Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> > Date: Wed, 8 Aug 2007 13:00:37 +0200
> > 
> > For me after 1day 20hours, the network is still up, with more than 
> > 1To of network traffic. HZ was 1000, i restart with HZ=100.
> 
> For me it's enough too but Thomas seems to doubt.

seem to doubt what? That rc2 fixes the symptom? That is a sure thing, 
and we never doubted that. I think you might have misunderstood what 
Thomas said and meant, so please just state your opinion unambiguously 
so that we can fix any mis-communication :)

	Ingo
