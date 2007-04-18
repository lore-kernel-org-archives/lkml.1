Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXDRGNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXDRGNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXDRGNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:13:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbXDRGNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:13:54 -0400
Date: Wed, 18 Apr 2007 08:13:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, gud@eth.net,
       arjan@linux.intel.com, milindchoudhary@gmail.com
Subject: Re: [PATCH] Document SPIN_LOCK_UNLOCKED/RW_LOCK_UNLOCKED deprecation
Message-ID: <20070418061330.GD23497@elte.hu>
References: <20070418014118.3F073DDE9F@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418014118.3F073DDE9F@ozlabs.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Ellerman <michael@ellerman.id.au> wrote:

> Apparently it's not cool anymore to use SPIN/RW_LOCK_UNLOCKED. There's 
> some mention of this in Documentation/spinlocks.txt, but that only 
> talks about dynamic initialisation.
> 
> A comment in the code mentioning the preferred usage would be good 
> IMHO.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

thanks,

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
