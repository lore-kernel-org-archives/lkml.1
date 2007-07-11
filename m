Return-Path: <linux-kernel-owner+w=401wt.eu-S1763015AbXGKVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763015AbXGKVje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXGKVj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:39:27 -0400
Received: from www.osadl.org ([213.239.205.134]:34901 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754977AbXGKVj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:39:26 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070711140244.b08ae4d9.rdunlap@xenotime.net>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <20070711140244.b08ae4d9.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 23:39:19 +0200
Message-Id: <1184189959.12353.150.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

On Wed, 2007-07-11 at 14:02 -0700, Randy Dunlap wrote: 
> I certainly haven't.  I can barely keep up with reading about 1/2
> of lkml emails.  And in my non-scientific method, I think that we
> are suffering from both (a) more patch submittals and (b) fewer
> qualified reviewers (per kernel KLOC) than we had 3-5 years ago.
> 
> I don't see how you can expect Andrew to review these or any other
> specific patchset.  Do you have some suggestions on how to clone
> Andrew?

Ingo was talking to Andi, the x86_64 maintainer, not to Andrew.

And I share his opinion that the maintainer of the subsystem, which is
affected by such a fundamental patch, could have at least shown any
public sign of interest, disgust, comment or what ever in a 3+ month
time frame.

Especially about a patch, which is a logical consequence of an almost
two years public and transparent effort to consolidate the time code in
the kernel.

I for my part have no problem maintaining the set for another round out
of tree and weed out eventually problems in -mm, but my expectation for
qualified response of the responsible maintainer is exactly zero right
now.

Thanks,

	tglx


