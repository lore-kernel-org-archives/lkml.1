Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbYGRMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbYGRMoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYGRMoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:44:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYGRMoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:44:11 -0400
Date: Fri, 18 Jul 2008 14:42:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core/stacktrace changes for v2.6.27
Message-ID: <20080718124255.GS6875@elte.hu>
References: <20080714144420.GA21632@elte.hu> <20080715013543.398c83d9.sfr@canb.auug.org.au> <20080714155617.GA3320@elte.hu> <20080714213232.GB6705@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714213232.GB6705@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> 
> s390 and probably other architectures will suffer from the same 
> compile bug. I sent you the patch below against linux-next to fix this 
> problem a couple of days ago: 
> http://marc.info/?l=linux-next&m=121577286607960&w=2
> 
> Subject: [PATCH] Add module.h include to stacktrace.c.

applied to tip/core/urgent, thanks Heiko.

	Ingo
