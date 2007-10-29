Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbXJ2XW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbXJ2XW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXJ2XWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:22:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbXJ2XWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:22:47 -0400
Date: Tue, 30 Oct 2007 00:22:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: balbir@linux.vnet.ibm.com, Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Message-ID: <20071029232219.GA12446@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <20071029200425.GA830@elte.hu> <20071029214321.GA25669@linux.vnet.ibm.com> <200710300019.28871.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710300019.28871.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> On Monday 29 October 2007, Balbir Singh wrote:
> > We'll also need this additional patch (untested),
> 
> OK. Both patches together do the trick. Gave it a nice long test run and got 
> no more weirdness.
> Tested-by: Frans Pop <elendil@planet.nl>

cool, thanks! I've queued it up for the next scheduler batch.

	Ingo
