Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYGCOBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYGCOBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYGCOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:00:53 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:38163 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbYGCOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:00:52 -0400
Date: Thu, 3 Jul 2008 10:34:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, suresh.b.siddha@intel.com,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, David Bahi <DBahi@novell.com>
Subject: Re: [ANNOUNCE] sched: schedtop utility
Message-ID: <20080703083412.GA7873@elte.hu>
References: <483545B4.BA47.005A.0@novell.com> <20080602124822.GA15410@in.ibm.com> <1212412051.6269.5.camel@lappy.programming.kicks-ass.net> <20080605052008.GA7635@in.ibm.com> <1213871234.10476.12.camel@twins> <20080701090006.GA7814@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701090006.GA7814@in.ibm.com>
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


* Ankita Garg <ankita@in.ibm.com> wrote:

> > OK, so task delay delay accounting is broken because it doesn't take
> > migration into account.

> Fixed. Pl. find the new patch below.

applied to tip/sched/devel - thanks Ankita.

	Ingo
