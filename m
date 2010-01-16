Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0APJ1P (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295Ab0APJ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:27:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0APJ1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:27:14 -0500
Date: Sat, 16 Jan 2010 10:26:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
Message-ID: <20100116092658.GA23999@elte.hu>
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
 <4B4345AF.9040600@suse.cz>
 <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com>
 <20100116063754.GC20342@elte.hu>
 <20100116183445.29fc5d50.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100116183445.29fc5d50.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Sat, 16 Jan 2010 07:37:54 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Given that Sam doesnt maintain the kbuild tree anymore, would this patch be a 
> > good fit for -mm perhaps?
> 
> There is a new kbuild tree maintainer: Michal Marek <mmarek@suse.cz>

Good. Michal, what do you think about David's patch?

	Ingo
