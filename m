Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYBAPsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYBAPsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYBAPsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:48:39 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46135 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbYBAPsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:48:38 -0500
Date: Fri, 1 Feb 2008 18:51:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] hrtimer_nanosleep: fix *rmtp handling
Message-ID: <20080201155116.GA25888@tv-sign.ru>
References: <20080201133758.GA25623@tv-sign.ru> <20080201142905.GA25833@tv-sign.ru> <alpine.LFD.1.00.0802011616000.9204@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802011616000.9204@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Thomas Gleixner wrote:
>
> On Fri, 1 Feb 2008, Oleg Nesterov wrote:
> 
> > (Andrew, the same patch, but re-diffed without the first one in series).
> 
> I pick them up and feed them through hrtimer.git, once all bugs are
> shaken out :)

Great, thanks.

Thomas, please wait a bit, I'll resend patches 3 and 5.

"PATCH 3/5" also suffers from the buggy "PATCH 1/5", and 5/5 should be
re-diffed.

Sorry to all for the noise.

Oleg.

