Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZHMJ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZHMJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZHMJ5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:57:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZHMJ5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:57:23 -0400
Date: Thu, 13 Aug 2009 11:56:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue remapped count
Message-ID: <20090813095640.GB28446@elte.hu>
References: <7c86c4470908111504i3a1e83b9k140fdaa717584a30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470908111504i3a1e83b9k140fdaa717584a30@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stephane eranian <eranian@googlemail.com> wrote:

> Hi,
> 
> I am trying to use the remapped counter feature
> on Intel Core. It does not work as expected.

it would be highly useful if you posted the .c files you used to 
test it.

Thanks,

	Ingo
