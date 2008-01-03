Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYACIoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYACIoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYACIos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:44:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39305 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYACIor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:44:47 -0500
Date: Thu, 3 Jan 2008 09:44:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up k8topology.c
Message-ID: <20080103084438.GE6794@elte.hu>
References: <20080102235816.GA8826@localhost.physics.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102235816.GA8826@localhost.physics.ucla.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0436]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlos R. Mafra <crmafra@gmail.com> wrote:

> x86: Cleanup k8topology.c
> 
> This patch fixes all errors pointed out by checkpatch.pl.
> 
>                                       errors   lines of code   errors/KLOC
> arch/x86/mm/k8topology_64.c (before)      72             185         389.1
> arch/x86/mm/k8topology_64.c (after)        0             185             0
> 
> No code changed.
> 
>    text    data     bss     dec     hex filename
>    1506       0       0    1506     5e2 k8topology_64.o.after
>    1506       0       0    1506     5e2 k8topology_64.o.before
>    
> md5sum:
> 
>    f9f48331a7eca4fc60d2a03369dc5f53  k8topology_64.o.after
>    f9f48331a7eca4fc60d2a03369dc5f53  k8topology_64.o.before
>    
> Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>

thanks, applied.

	Ingo
