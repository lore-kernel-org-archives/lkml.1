Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZLDTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZLDTQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZLDTQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:16:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:62603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbZLDTQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:16:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,343,1257148800"; 
   d="scan'208";a="519865606"
From: "Luck, Tony" <tony.luck@intel.com>
To: Luming Yu <luming.yu@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Felix Blyakher <felixb@sgi.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, Bob Picco <bob.picco@hp.com>
Date: Fri, 4 Dec 2009 11:16:22 -0800
Subject: RE: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
 	enable ftrace for ia64
Thread-Topic: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
 	enable ftrace for ia64
Thread-Index: Acp0s3cSVqCxQxTvTtyG48Q+MPHAqgAYiIqg
Message-ID: <4BDB13256095B24D9644F65379E604265C12@orsmsx505.amr.corp.intel.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
	 <20090828062212.GB11552@elte.hu>
 <3877989d0912032329u7c05a761wfdd5c7000b43218d@mail.gmail.com>
In-Reply-To: <3877989d0912032329u7c05a761wfdd5c7000b43218d@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luming,

Can you send the config file that you used to test this.

I turned on a bunch of LOCKDEP related things, but I may have
stumbled into areas that aren't working yet because my kernel
didn't boot (or say anything on the console, even with early
serial uart console enabled).

I'd like to take this patch so we can fix it up with incremental
patches ... but I'd like a better idea of what works now and
what doesn't.

Thanks

-Tony
