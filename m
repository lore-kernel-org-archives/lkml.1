Return-Path: <linux-kernel-owner+w=401wt.eu-S1423064AbXCGRnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423064AbXCGRnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965574AbXCGRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:42:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbXCGRmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:42:35 -0500
Date: Wed, 7 Mar 2007 18:39:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kirk Kuchov <kirk.kuchov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Eric Dumazet <dada1@cosmosbay.com>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070307173953.GA27603@elte.hu>
References: <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com> <20070303100625.GA22557@2ka.mipt.ru> <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com> <20070303203140.GA756@2ka.mipt.ru> <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com> <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com> <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com> <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com> <20070306081935.GB2040@elf.ucw.cz> <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kirk Kuchov <kirk.kuchov@gmail.com> wrote:

> I don't believe I'm wasting my time explaining this. They don't exist 
> as /dev/null, they are just fucking _LINKS_.
[...]
> > Either stop flaming kernel developers or become one. It is that 
> > simple.
> 
> If I were to become a kernel developer I would stick with FreeBSD. 
> [...]

Hey, really, this is an excellent idea: what a boon you could become to 
FreeBSD, again! How much they must be longing for your insightful 
feedback, how much they must be missing your charming style and tactful 
approach! I bet they'll want to print your mails out, frame them and 
hang them over their fireplace, to remember the good old days on cold 
snowy winter days, with warmth in their hearts! Please?

	Ingo
