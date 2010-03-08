Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0CHVdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:33:52 -0500
Received: from www.tglx.de ([62.245.132.106]:55153 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab0CHVdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:33:47 -0500
Date: Mon, 8 Mar 2010 22:33:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: greg kh <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, aaro.koskinen@iki.fi,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH] Fix oops on !GENERIC_TIME systems when accessing
 current_clocksource
In-Reply-To: <1268083327.3726.19.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003082232380.22855@localhost.localdomain>
References: <1267475683.4216.61.camel@localhost.localdomain> <1268083327.3726.19.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, john stultz wrote:

> On Mon, 2010-03-01 at 12:34 -0800, john stultz wrote:
> > No one has replied to this, so I wanted to send it out again.
> 
> Just another ping here. I know the patch has made it to -tip, but its
> something that should be needed for 2.6.34, 2.6.33-stable.

I'm going to send a pull request tomorrow.

Thanks,

	tglx
