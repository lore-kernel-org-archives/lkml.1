Return-Path: <linux-kernel-owner+w=401wt.eu-S1030240AbXBORBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240AbXBORBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030220AbXBORBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:01:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030240AbXBORB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:01:28 -0500
Date: Thu, 15 Feb 2007 17:58:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 04/14] syslets: core, data structures
Message-ID: <20070215165806.GA5343@elte.hu>
References: <20070215165224.GE4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215165224.GE4285@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4950]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Index: linux/kernel/async.h
> ===================================================================
> --- /dev/null
> +++ linux/kernel/async.h
> @@ -0,0 +1,2 @@
> +
> +

this one sneaked in accidentally - i have removed it from my queue now.

	Ingo
