Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbXB0MW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbXB0MW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXB0MW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:22:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933074AbXB0MW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:22:27 -0500
Date: Tue, 27 Feb 2007 13:15:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: threadlets as 'naive pool of threads', epoll, some measurements
Message-ID: <20070227121539.GA20089@elte.hu>
References: <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu> <20070226122521.GA19039@2ka.mipt.ru> <20070226125054.GA6997@elte.hu> <20070226143201.GB31629@2ka.mipt.ru> <20070226202338.GA23357@elte.hu> <20070227081611.GB16295@2ka.mipt.ru> <20070227082757.GA23617@elte.hu> <20070227103711.GD23170@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227103711.GD23170@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> So, ok, no micro-thread name.

thanks!

	Ingo
