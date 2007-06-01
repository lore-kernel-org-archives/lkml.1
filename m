Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbXFAGXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbXFAGXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXFAGW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:22:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbXFAGW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:22:56 -0400
Date: Fri, 1 Jun 2007 08:21:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Ian Kumlien <iank@bredband.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-ID: <20070601062155.GA31126@elte.hu>
References: <1180478288.20546.39.camel@chaos> <20070530113825.GA5203@atjola.homenet> <20070530144449.36811a4d.dada1@cosmosbay.com> <20070530131458.GA5432@atjola.homenet> <20070531102047.GG19272@pomac.netswarm.net> <20070531142522.GA16690@atjola.homenet> <20070531171007.5780e5e6.dada1@cosmosbay.com> <20070531152709.GA18775@atjola.homenet> <1180652361.30698.11.camel@pi.pomac.com> <20070531230903.GA19353@atjola.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070531230903.GA19353@atjola.homenet>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> > Fix the comment below and you can add:
> > Signed-off-by: Ian Kumlien <pomac@vapor.com>
> > 
> > It's currently been running for the longest period ever, ie, 11 minutes
> > =)
> 
> Finally! :-)

cool! Great detective work Björn!

> Thanks to Eric Dumazet for reminding me of the memory barriers.
> 
> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> Signed-off-by: Ian Kumlien <pomac@vapor.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
