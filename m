Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbXJVP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbXJVP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXJVP5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:57:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXJVP5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:57:06 -0400
Date: Mon, 22 Oct 2007 17:56:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@skynet.ie>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071022155655.GC1214@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu> <20071002172135.GA12182@skynet.ie> <4702C1AD.3090701@tmr.com> <1191371855.2708.26.camel@localhost> <20071003082157.GB32218@elte.hu> <20071003125138.GA8636@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003125138.GA8636@skynet.ie>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Mel Gorman <mel@skynet.ie> wrote:

> Subject: Document profile=sleep requiring CONFIG_SCHEDSTATS
> 
> profile=sleep only works if CONFIG_SCHEDSTATS is set. This patch notes 
> the limitation in Documentation/kernel-parameters.txt and prints a 
> warning at boot-time if profile=sleep is used without 
> CONFIG_SCHEDSTAT.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

thanks, applied.

	Ingo
