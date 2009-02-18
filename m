Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbZBRWtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbZBRWtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759533AbZBRWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:42:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZBRWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:42:43 -0500
Subject: Re: [RFT 2/4] Add mod_timer_noact
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, shemminger@vyatta.com, kaber@trash.net, rick.jones2@hp.com,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       gandalf@wlug.westbo.se, linux-kernel@vger.kernel.org
In-Reply-To: <20090218.140455.142445208.davem@davemloft.net>
References: <20090218110144.GA4100@elte.hu>
	 <20090218.133959.193699273.davem@davemloft.net>
	 <20090218215140.GA3505@elte.hu>
	 <20090218.140455.142445208.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 23:42:27 +0100
Message-Id: <1234996947.4799.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 14:04 -0800, David Miller wrote:

> And as others have pointed out you also failed to recognize
> the context of the patch posting.  It was part of a sequence
> of patches for people to test some experimental netfilter
> performance optimizations.  "RFT" was prefixed to every patch
> subject line, if any more indication was necessary.

Be that as it may, its a maintainer seeing a patch against his
subsystem, reviewing it (albeit early -- we should all want to get
around to reviewing that early) and asking for some clarification.

The fact is, Steve's changelog was very unclear to people not intimately
familiar with the problem space. Asking some clarification just isn't
weird in any way.

> Yet you object that the patches are against the networking
> and netfilter trees.
> 
> Again, your reactions were knee-jerk, by every definition of the
> term.
> 
> I know how you work Ingo, you want to be fast and efficient.
> But often, your "fast and efficient" is "careless", and this
> wastes everyone elses time and in the final analysis makes
> you "slow".

Can we please leave it at this, the technical issue seems to be delt
with. You and Ingo seems to have a gift to rub each other the wrong way,
it would be grand if you could both try to be a little forgiving and
just focus on the code/technical issues which makes Linux to what it is,
technically excellent ;-)

