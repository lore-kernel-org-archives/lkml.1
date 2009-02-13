Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZBMKGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZBMKGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbZBMKG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:06:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbZBMKG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:06:26 -0500
Date: Fri, 13 Feb 2009 11:06:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
Message-ID: <20090213100606.GC1300@elte.hu>
References: <20090205112414.104100700@chello.nl> <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang> <20090206151832.GL18368@elte.hu> <1234161961.5991.41.camel@minggr.sh.intel.com> <20090209214723.GA2664@elte.hu> <1234270044.23438.7.camel@twins> <1234318148.2604.370.camel@ymzhang> <20090212110500.GB23665@elte.hu> <1234516517.32144.11.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234516517.32144.11.camel@minggr.sh.intel.com>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> 
> > FYI, in Linus's latest tree (v2.6.29-rc4-175-gb578f3f or later), all
> > the scheduler related performance regressions should be addressed.
> > 
> > Could you please double-check that there's no performance regression
> > remaining?
> 
> I have tested the latest git tree(071a0bc2).
> hackbench, volanoMark, oltp, specjbb2005 regressions are all fixed.

Great - thanks for testing it!

	Ingo
