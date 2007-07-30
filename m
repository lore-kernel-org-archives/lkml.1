Return-Path: <linux-kernel-owner+w=401wt.eu-S968088AbXG3TJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968088AbXG3TJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966625AbXG3TIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:08:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967750AbXG3TIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:08:45 -0400
Date: Mon, 30 Jul 2007 21:08:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: John <darknessenvelops@gmail.com>, Kasper Sandberg <lkml@metanurb.dk>,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070730190822.GB28554@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <Pine.LNX.4.64.0707300914160.11330@asgard.lang.hm> <20070730190147.GC20901@elte.hu> <Pine.LNX.4.64.0707301202260.12232@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707301202260.12232@asgard.lang.hm>
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


* david@lang.hm <david@lang.hm> wrote:

> > ah, you mean Kasper Sandberg's report? That turned out to be based 
> > on an older CFS version, not v2.6.23-rc1. Kasper said he'll redo his 
> > tests, and if there's still any regression left we'll fix it.
> 
> probably. I delete lkml messages pretty agressivly so I don't have 
> them around to refer to.

lkml.org is your friend:

 http://lkml.org/lkml/2007/7/27/423
 http://lkml.org/lkml/2007/7/28/50
 http://lkml.org/lkml/2007/7/30/195

:-)

	Ingo
