Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbYGRP7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbYGRP7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYGRP7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:59:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53606 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYGRP7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:59:16 -0400
Date: Fri, 18 Jul 2008 17:58:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] Fix typos from signal_32/64.h merge
Message-ID: <20080718155846.GX6875@elte.hu>
References: <200807141740.23750.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807141740.23750.herton@mandriva.com.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0063]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> Fallout from commit 33185c504f8e521b398536b5a8d415779a24593c ("x86: 
> merge signal_32/64.h")
> 
> Thanks to Dick Streefland who provided an useful testcase on 
> http://lkml.org/lkml/2008/3/17/205 (only applicable to 2.6.24.x), that 
> helped a lot as a deterministic way to bisect an issue that leaded to 
> this fix.

applied to tip/x86/urgent, thanks Herton!

	Ingo
