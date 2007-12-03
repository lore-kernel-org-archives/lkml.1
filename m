Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXLCN7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXLCN7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXLCN7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:59:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbXLCN7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:59:39 -0500
Date: Mon, 3 Dec 2007 14:59:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203135916.GC4245@elte.hu>
References: <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <20071203122833.GA20232@elte.hu> <20071203124144.GC2986@one.firstfloor.org> <20071203130003.GA26372@elte.hu> <20071203131442.GA4004@one.firstfloor.org> <20071203132955.GA31354@elte.hu> <20071203144128.16a3dd53@astralstorm.puszkin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203144128.16a3dd53@astralstorm.puszkin.org>
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


* Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org> wrote:

> On Mon, 3 Dec 2007 14:29:56 +0100
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > feedback about an impending catastrophy has been duly noted
> > > 
> > > The point was less about an impending catastrophe, but more of a 
> > > timebomb ticking until the next widely used release.
> 
> I think I know why Andi is so much against backtraces: he has some log 
> filter listening on netconsole mailing him with suspicious log 
> messages.

Andi, is that true? If yes, why didnt Andi state this concern outright, 
instead of pooh-pooh-ing the patch on various other grounds?

	Ingo

