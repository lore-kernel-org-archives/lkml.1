Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbZCYAxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbZCYAxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZCYAdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:33:55 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56291 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753763AbZCYAdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:33:54 -0400
Date: Wed, 25 Mar 2009 08:33:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090325003311.GD2297@gondor.apana.org.au>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324153616.GA31143@elte.hu> <20090324154717.GA7506@elte.hu> <20090324155911.GA30824@gondor.apana.org.au> <20090324160241.GA11060@elte.hu> <20090324191900.GA24595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324191900.GA24595@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 08:19:00PM +0100, Ingo Molnar wrote:
>
> Hm, i justhad a test failure (hung interface) with this too.

Was this with NAPI on or off?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
