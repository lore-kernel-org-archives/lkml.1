Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXK3KJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXK3KJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXK3KJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:09:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbXK3KJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:09:02 -0500
Date: Fri, 30 Nov 2007 11:08:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071130100845.GB2201@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200711301346.22573.nickpiggin@yahoo.com.au> <1196392527.25646.65.camel@ymzhang> <200711301429.15664.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711301429.15664.nickpiggin@yahoo.com.au>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Haven't we been asking JVMs to use futexes or posix locking for years 
> and years now? [...]

i'm curious, with what JVM was it tested and where's the source so i can 
fix their locking for them? Can the problem be reproduced with:

  http://download.fedora.redhat.com/pub/fedora/linux/development/source/SRPMS/java-1.7.0-icedtea-1.7.0.0-0.20.b23.snapshot.fc9.src.rpm

?

	Ingo
