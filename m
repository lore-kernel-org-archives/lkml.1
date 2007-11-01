Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbXKAIcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbXKAIcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXKAIcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:32:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbXKAIcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:32:06 -0400
Date: Thu, 1 Nov 2007 09:31:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Avi Kivity <avi@qumranet.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
Message-ID: <20071101083139.GB8459@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com> <20071024123258.GA28653@elte.hu> <20071024123650.GA31562@elte.hu> <20071024181107.GA15250@elte.hu> <20071031203442.7e161692.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031203442.7e161692.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> > > and this followup patch is needed too if my patch is applied.
> > 
> > plus the patch below is needed too in addition.
> > 
> > 	Ingo
> 
> Hi,
> I'm still hitting this build error.  Are these 3 patches not yet
> merged??

i thought we agreed it would go in via KVM. Can send it as part of the 
scheduler git tree too, these patches are working fine for me. Avi?

	Ingo
