Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZDOTjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZDOTjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZDOTj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:39:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZDOTj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:39:26 -0400
Date: Wed, 15 Apr 2009 21:38:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] x86: used used_vectors in init_IRQ
Message-ID: <20090415193827.GB32675@elte.hu>
References: <49E62DFD.6010904@kernel.org> <20090415192550.GA27004@elte.hu> <49E636F2.7030902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E636F2.7030902@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> 
> > Note, i removed the -stable tag because i dont think .29 nor 
> > .30-rc2 is affected. Your patch to irqinit*.c (and the later 
> > unification by Pekka) is something still pending in the 
> > perfcounters and x86 trees, queued for .31.
> 
> not sure .29, but it seems we need this for 2.6.30
> 
> or you want me to produce one against to linus tree?

Yes, do one please.

	Ingo
