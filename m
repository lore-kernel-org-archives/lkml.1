Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbXKTWnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbXKTWnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbXKTWnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:43:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51055 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbXKTWnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:43:02 -0500
Date: Tue, 20 Nov 2007 23:42:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Zach Brown <zach.brown@oracle.com>,
       Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
Message-ID: <20071120224206.GB11250@elte.hu>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <47432666.6070503@oracle.com> <474331B7.6020802@zytor.com> <20071120222227.GH24156@elte.hu> <Pine.LNX.4.64.0711201431490.15098@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711201431490.15098@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > whether that interpreted syslet language survives is still an open 
> > question - it was extremely ugly when i wrote the first version of 
> > it and it only got uglier since then :-)
> 
> Aha! You admitted it finally :)

damn :-)

but if the only alternative is to be fundamentally slower, i am not 
afraid of some ugliness :-)

	Ingo
