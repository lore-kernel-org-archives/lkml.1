Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYIKL4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYIKL4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYIKL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:56:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYIKL43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:56:29 -0400
Date: Thu, 11 Sep 2008 13:56:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Nixon <alex.nixon@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Globally defining phys_addr_t
Message-ID: <20080911115608.GA8482@elte.hu>
References: <48C8D76B.10901@goop.org> <20080911095311.GB7795@elte.hu> <20080911032058.538ceb7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911032058.538ceb7c.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Also, i dont see Andrew's signoffs in the patches, and that's the 
> > true path of these patches which should be preserved: you => -mm => 
> > -tip.
> 
> Not really.  These went
> 
> JF -> mm
> 
> and
> 
> JF -> you

yeah - it was just a small detail: i generally try to preserve the 
testing (and review) track record of patches. So since they've been in 
-mm for some time, ideally that fact should be preserved.

	Ingo
