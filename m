Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZA2U2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZA2U2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZA2U2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:28:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZA2U2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:28:07 -0500
Date: Thu, 29 Jan 2009 21:27:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, cpufreq@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: circular locking dependency on shutdown
Message-ID: <20090129202747.GC12819@elte.hu>
References: <1233255049.4067.12.camel@johannes.local> <1233258847.4012.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233258847.4012.0.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Thu, 2009-01-29 at 19:51 +0100, Johannes Berg wrote:
> > Hi,
> > 
> > Every time I shut down my machine with a 2.6.29-rc2 kernel,
> 
> Seems it's gone in -rc3, sorry for the noise!

yeah - there were a few fixes in this area.

	Ingo

