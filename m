Return-Path: <linux-kernel-owner+w=401wt.eu-S2992551AbXCWUBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992551AbXCWUBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXCWUBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:01:14 -0400
Received: from www.osadl.org ([213.239.205.134]:35796 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934194AbXCWUA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:00:58 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 21:08:20 +0100
Message-Id: <1174680500.10840.346.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> Subject    : soft lockup detected on CPU#0
> References : http://lkml.org/lkml/2007/3/3/152
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>              Ingo Molnar <mingo@elte.hu>
> Status     : unknown

Michal,

any news on that one ? 

You said the same problem exists in 2.6.20.1. Has this been resolved in
2.6.20.2/3

Thanks,

	tglx


