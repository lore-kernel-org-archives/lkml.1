Return-Path: <linux-kernel-owner+w=401wt.eu-S1764760AbZFLRfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764760AbZFLRfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764176AbZFLRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:35:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763836AbZFLRf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:35:29 -0400
Date: Fri, 12 Jun 2009 19:35:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] x86: perf_counter update AMD hw caching
	related event table
Message-ID: <20090612173520.GB22015@elte.hu>
References: <1244714289.6923.0.camel@ht.satnam> <1244714379.6923.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244714379.6923.2.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> AMD shares same hw caching related event table.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   36 +++++++++++++++---------------------
>  1 files changed, 15 insertions(+), 21 deletions(-)

Looks good - but your patch does not apply anymore. (Neither to -git 
nor to -tip)

	Ingo
