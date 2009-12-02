Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZLBB6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZLBB6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZLBB6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:58:20 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:43497 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZLBB6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:58:19 -0500
Date: Wed, 2 Dec 2009 01:58:23 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>, Michal Simek <monstr@monstr.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via
 cnt32_to_63().
In-Reply-To: <20091123084241.GA23635@elte.hu>
Message-ID: <alpine.LFD.2.00.0912020148200.23935@eddie.linux-mips.org>
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com> <20091122081328.GB24558@elte.hu> <4B0925BD.6070507@ru.mvista.com> <20091122180616.GB24711@elte.hu> <20091122202314.GB1941@linux-mips.org>
 <20091123084241.GA23635@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Ingo Molnar wrote:

> > > >   MIPS's is not really a proper English. :-)
> > > 
> > > AFAIK 'MIPS' is not the plural of 'MIP' (but an acronym ending with 
> > > 'S'), hence the possessive form would be MIPS's.
> > 
> > MIPS Technologies' IP lawyers insist that MIPS is a proper name and 
> > not an acronym - this position has certain advantages in trademark 
> > law.
> 
> That too seems to support my point that "MIPS's" is the right spelling.

 My understanding is that "MIPS" is actually meant (as far as IP law is 
concerned) to be an adjective, so you can't really make a possessive form 
out of it as it is irrelevant.  The correct form IMHO is thus simply: 
"MIPS sched_clock implementation" which happens to sound the best to me 
too.

  Maciej
