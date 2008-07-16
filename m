Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYGPRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYGPRNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYGPRNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:13:01 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3124 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYGPRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:13:00 -0400
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, nhorman@tuxdriver.com,
       simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, herbert@gondor.apana.org.au
In-Reply-To: <20080715214929.GA18268@martell.zuzino.mipt.ru>
References: <487BE071.80101@simon.arlott.org.uk>
	 <20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
	 <20080715113304.GA30565@elte.hu>
	 <20080715.134407.150543177.davem@davemloft.net>
	 <20080715214929.GA18268@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 09:57:26 -0700
Message-Id: <1216227446.8292.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 01:49 +0400, Alexey Dobriyan wrote:
> On Tue, Jul 15, 2008 at 01:44:07PM -0700, David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > > Note that the new crypto/prng.c driver has very bad quality:
> > I think we should merge new drivers as aggressively as possible.
> Well, I don't have strong opinion about this exact statement, but
> Ingo, COULD YOU PLEASE [...] STOP THIS
> CHECKPATCH.PL-AS-INDICATOR HORSESHIT !

Coding style conformity (easy and clinical) and quality
(hard and emotional) are only weakly correlated in software.

I think that Ingo sometimes conflates them and he should be more
selective when using the "quality" term.

I think he recognizes this, he just hasn't done much about it.
http://lkml.org/lkml/2008/2/22/307

Ingo, could you please just substitute conformity for quality
in these sorts of posts?  Perhaps you could also change the
name of your code-quality script to style-conformity?

