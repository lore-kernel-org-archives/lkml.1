Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbXGaIdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbXGaIdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbXGaIck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:32:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbXGaIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:32:38 -0400
Date: Tue, 31 Jul 2007 10:32:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: kriko <kristjan.ugrin@gmail.com>
Cc: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: SD still better than CFS for 3d   ?(was Re:
	2.6.23-rc1)
Message-ID: <20070731083230.GA14039@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <op.twbll7ugatcbto@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.twbll7ugatcbto@linux.site>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* kriko <kristjan.ugrin@gmail.com> wrote:

> I'm trying to get kernel 2.6.22-ck and 2.6.23-rc1 work to test the new 
> cfs scheduler, but I get broken system. Networking is totally broken 
> (cannot find module for my marvell yukon gigabit ethernet in kconfig), 
> firewall / routing doesn't work (a bunch of error messages when 
> firewall script starts). Were there drastic changes in networking 
> support? Currently I'm running 2.6.21-ck1 on opensuse 10.2 and it 
> works fine.

pick up 2.6.22-cfsv19 from:

   http://people.redhat.com/mingo/cfs-scheduler/

2.6.23-rc1 is indeed a bit experimental.

	Ingo
