Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZFLLkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZFLLkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZFLLkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:40:01 -0400
Received: from ozlabs.org ([203.10.76.45]:34346 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZFLLkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:40:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: use zalloc_cpumask_var in arch_early_irq_init
Date: Fri, 12 Jun 2009 21:10:00 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A318034.3010102@kernel.org>
In-Reply-To: <4A318034.3010102@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906122110.01032.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 07:37:48 am Yinghai Lu wrote:
> So could make sure MAXSMP get clearred cpumask
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Ingo, this only applies to your tree; can you take it?

Thanks,
Rusty.
