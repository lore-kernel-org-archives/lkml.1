Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYFSPUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYFSPUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYFSPT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:19:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYFSPT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:19:58 -0400
Date: Thu, 19 Jun 2008 17:19:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] - Increase MAX_APICS for very large x86_64 configs
Message-ID: <20080619151940.GA14899@elte.hu>
References: <20080616170910.GA24930@sgi.com> <20080619101030.GF15228@elte.hu> <20080619103242.GA13213@elte.hu> <20080619150209.GA9295@sgi.com> <20080619151732.GA12964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619151732.GA12964@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > > unfortunately it didnt last long, -tip randconfig auto-testing found 
> > > that your patch causes a bootup crash:
> > 
> > I built a "git-checkout -b tip-latest tip/auto-latest" tree but get 
> > compile errors. Is this the right tree??
> 
> no, you should check out tip/master.

ah, i see - the readme was suggesting auto-latest - my bad. I've updated 
the readme.

	Ingo
