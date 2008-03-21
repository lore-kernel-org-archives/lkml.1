Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYCUKdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYCUKdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYCUKdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:33:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYCUKde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:33:34 -0400
Date: Fri, 21 Mar 2008 11:33:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64 ia32 ptrace vs -ENOSYS
Message-ID: <20080321103322.GN20420@elte.hu>
References: <20080317045741.2F6A526F995@magilla.localdomain> <20080319151758.29e02848.akpm@linux-foundation.org> <20080319233601.958B426F995@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319233601.958B426F995@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > IOW: is it a 2.6.25 thing and if so, why?
> 
> No hurry.  It's been broken forever (regression vs native 32-bit). 
> (OTOH, the fixes are quite safe.)

thanks Roland, i've applied your fixes.

	Ingo
