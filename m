Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbXHXIcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbXHXIcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXHXIce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:32:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764251AbXHXIcd (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:32:33 -0400
Date: Fri, 24 Aug 2007 10:32:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: RT Users List <linux-rt-users@vger.kernel.org>,
       LKML <Linux-kernel@vger.kernel.org>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: [PATCH RT] - trivial branch in scheduler.
Message-ID: <20070824083222.GA22260@elte.hu>
References: <1187943548.16573.10.camel@sx.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187943548.16573.10.camel@sx.thebigcorporation.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4968]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sven-Thorsten Dietrich <sven@thebigcorporation.com> wrote:

> 
> Hi Ingo,
> 
> the trivial code is in various RT patches as well as in 2.6.23-rc git's
> scheduler.
> 
> Thanks
> 
> Sven
> 
> Remove trivial conditional branch in Linux RT CFS 
> scheduler's can_migrate_task function.
> 
> signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>

thanks, applied.

	Ingo
