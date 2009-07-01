Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGAVOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGAVOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZGAVOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:14:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZGAVOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:14:22 -0400
Date: Wed, 1 Jul 2009 23:14:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, vapier.adi@gmail.com,
       lethal@linux-sh.org
Subject: Re: [RFC v2] kernel/printk.c - handling more than one CON_BOOT
Message-ID: <20090701211411.GD631@elte.hu>
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <200906302251.52966.rgetz@blackfin.uclinux.org> <20090701124414.fe188893.akpm@linux-foundation.org> <200907011650.19173.rgetz@blackfin.uclinux.org> <20090701140128.7924f3c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701140128.7924f3c4.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > I think it would be useful if we had a description of the new 
> > > design, similar to your description of the "Today" behaviour 
> > > above.  Perhaps as a comment over register_console()?
> > 
> > Can do - do you want it as v3 or on-top of this one?
> 
> I'm easy either way.  Ingo might have applied to one of his trees, 
> in which case a replacement patch might cause him problems, dunno.

Not yet - i was waiting for feedback from you and Linus. Would be 
nice to have a from-scratch v3 that adresses all the review 
feedback.

	Ingo
