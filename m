Return-Path: <linux-kernel-owner+w=401wt.eu-S932761AbZHUUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbZHUUgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZHUUgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:36:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbZHUUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:36:15 -0400
Date: Fri, 21 Aug 2009 22:36:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Kelly Bowa <kelly.bowa@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Atom processor inclusion
Message-ID: <20090821203605.GC15439@elte.hu>
References: <20090820130648.6e7236f7@titus> <20090820105029.GF29093@elte.hu> <200908201433.54785.tobias.doerffel@gmail.com> <4A8EE544.6020002@zytor.com> <4A8EE606.7000807@linux.intel.com> <20090821193841.GA5356@elte.hu> <4A8F0481.7050003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8F0481.7050003@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/21/2009 12:38 PM, Ingo Molnar wrote:
> > 
> > makes sense.
> > 
> 
> OK, but I think that's a separate project.  For now, I'll put the 
> patch as-is into tip:x86/cpu.

I agree with the review feedback given - we can make merge of that 
dependent on measurements, etc.

	Ingo
