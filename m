Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZBAQmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZBAQmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZBAQma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:42:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZBAQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:42:29 -0500
Date: Sun, 1 Feb 2009 17:42:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip V2] x86: irqinit_32.c fix compilation warning
Message-ID: <20090201164225.GA26825@elte.hu>
References: <1233506259.5737.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233506259.5737.3.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> >From baf127da04513547ef292079c91147eefed333a3 Mon Sep 17 00:00:00 2001
> From: jaswinder <jaswinder@JSR.SATNAM>
> Date: Sun, 1 Feb 2009 21:15:19 +0530
> Subject: [PATCH] x86: irqinit_32.c fix compilation warning
> 
> Fix:
> 
>   arch/x86/kernel/irqinit_32.c:124: warning: 'smp_intr_init' defined but not used
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/irqinit_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to tip/perfcounters/core (which introduced this), thanks Jaswinder!

	Ingo
