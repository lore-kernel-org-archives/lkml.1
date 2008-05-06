Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbYEFVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbYEFVcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933523AbYEFVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:24:20 -0400
Received: from www.tglx.de ([62.245.132.106]:45676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933465AbYEFVYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:24:17 -0400
Date: Tue, 6 May 2008 23:21:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Daniel Walker <dwalker@mvista.com>, johnstul@us.ibm.com,
       ralf@linux-mips.org, anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
In-Reply-To: <20080506141808.900ace98.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805062321070.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com> <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de> <1210091954.17132.142.camel@localhost.localdomain> <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de> <1210106014.17132.172.camel@localhost.localdomain>
 <alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de> <1210107675.17132.181.camel@localhost.localdomain> <20080506141808.900ace98.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Andrew Morton wrote:
> On Tue, 06 May 2008 14:01:15 -0700
> Daniel Walker <dwalker@mvista.com> wrote:
> 
> > your sloppy wording "pulled from the MIPS tree"
> 
> Let it just be said: the amount of time which is lost due to poor patch
> descriptions exceeds the amount of time which was saved in not
> bothering to write good patch descriptions.
> 
> That it all.

Amen to that.
 
