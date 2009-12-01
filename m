Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZLAVjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZLAVjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZLAVjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:39:40 -0500
Received: from www.tglx.de ([62.245.132.106]:49985 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZLAVjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:39:39 -0500
Date: Tue, 1 Dec 2009 22:39:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joseph Parmelee <jparmele@wildbear.com>
cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
In-Reply-To: <alpine.LNX.2.00.0912011428350.855@bruno>
Message-ID: <alpine.LFD.2.00.0912012236120.24119@localhost.localdomain>
References: <alpine.LNX.2.00.0911291057100.2912@bruno> <4B143AE8.5090608@us.ibm.com> <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain> <alpine.LNX.2.00.0912011428350.855@bruno>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph,

On Tue, 1 Dec 2009, Joseph Parmelee wrote:
> On Mon, 30 Nov 2009, Thomas Gleixner wrote:
> > Could you also please do a quick check in which kernel version this
> > got introduced ?
>
> The problem first appears in 2.6.31 and persists through the current
> 2.6.31.6.
> 
> The problem does not appear in 2.6.29 and 2.6.30 versions.

thanks for testing. Can you please provide your 2.6.31.x .config file ?

Thanks,

	tglx
