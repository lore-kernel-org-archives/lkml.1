Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbYEFUdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbYEFUdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbYEFUdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:33:32 -0400
Received: from www.tglx.de ([62.245.132.106]:43291 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339AbYEFUdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:33:31 -0400
Date: Tue, 6 May 2008 22:25:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: shift helper
In-Reply-To: <1210091954.17132.142.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>  <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de> <1210091954.17132.142.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Daniel Walker wrote:
> On Tue, 2008-05-06 at 02:52 +0200, Thomas Gleixner wrote:
> > On Thu, 1 May 2008, Daniel Walker wrote:
> > 
> > > This is a little helper I pulled from the mips tree.
> > ... 
> > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > 
> > And who is the original author of this little helper in the MIPS tree?
> 
> commit 16b7b2ac0148e839da86af8747b6fa4aad43a9b7
> Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Wouldn't it be appropriate to assign the authorship in the usual form
i.e.:

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp> 

on top of the patch and keep the original changelog message intact
including the Signed-off-by of the author and Ralf ?

Aside of the broken S-O-B chain this is a blatant usurpation of
somebody else's work.

You answered my question about the real author without hesitation, so
I guess it was not your intention to claim authorship of someone
else's work, but this is on the verge of plagiarism and might bring
you into serious trouble.

You should know the proper procedures by now and this is exactly the
kind of sloppiness that you constantly show and what makes it almost
impossible to do any cooperative work with you.

Thanks,

	tglx
