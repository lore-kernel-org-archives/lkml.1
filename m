Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbZFMFEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbZFMFEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZFMFEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:04:32 -0400
Received: from ozlabs.org ([203.10.76.45]:51268 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZFMFEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:04:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: use zalloc_cpumask_var in arch_early_irq_init
Date: Sat, 13 Jun 2009 14:34:30 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A318034.3010102@kernel.org> <200906122110.01032.rusty@rustcorp.com.au> <20090612150042.GB31667@elte.hu>
In-Reply-To: <20090612150042.GB31667@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906131434.31190.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009 12:30:42 am Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Fri, 12 Jun 2009 07:37:48 am Yinghai Lu wrote:
> > > So could make sure MAXSMP get clearred cpumask
> > >
> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > Ingo, this only applies to your tree; can you take it?
>
> should apply to upstream too so could go into your tree with the
> other cpumask changes, right?

Yep, I hadn't pulled for a while.  I'll take it now.

Thanks,
Rusty.
