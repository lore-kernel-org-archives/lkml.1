Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbZBMJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbZBMJSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZBMJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:18:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:18885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZBMJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:18:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,201,1233561600"; 
   d="scan'208";a="665328997"
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <20090212110500.GB23665@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang>
	 <20090206151832.GL18368@elte.hu>
	 <1234161961.5991.41.camel@minggr.sh.intel.com>
	 <20090209214723.GA2664@elte.hu> <1234270044.23438.7.camel@twins>
	 <1234318148.2604.370.camel@ymzhang>  <20090212110500.GB23665@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 17:15:17 +0800
Message-Id: <1234516517.32144.11.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> FYI, in Linus's latest tree (v2.6.29-rc4-175-gb578f3f or later), all
> the scheduler related performance regressions should be addressed.
> 
> Could you please double-check that there's no performance regression
> remaining?

I have tested the latest git tree(071a0bc2).
hackbench, volanoMark, oltp, specjbb2005 regressions are all fixed.

Thanks,
Lin Ming

