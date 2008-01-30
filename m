Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYA3CCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYA3CCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYA3CCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:02:37 -0500
Received: from c60.cesmail.net ([216.154.195.49]:35378 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYA3CCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:02:36 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
In-Reply-To: <20080130002514.GA1802@does.not.exist>
References: <1201641765.18773.35.camel@dv>
	 <20080129225701.GS8767@does.not.exist> <1201650267.18773.118.camel@dv>
	 <20080130002514.GA1802@does.not.exist>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 21:02:35 -0500
Message-Id: <1201658555.24898.27.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-30 at 02:25 +0200, Adrian Bunk wrote:

> > > It is interesting that someone posting with an @gnu.org address claims
> > > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> > > not a copyright violation.
> > 
> > No, I'm representing myself only.  I don't think you represent all
> > kernel developers when posting from the kernel.org address.
> 
> I'm not using my @kernel.org address except for kernel issues and I'm 
> not using a company address in linux-kernel discussions.
> 
> Mailing lists of a project or a company are something completely 
> different from using a project or company address outside of the 
> project.

OK, I'll think about it.

> > I, for one, would welcome an informed position of the FSF.  It may have
> > interesting implications for Wine, ReactOS, mplayer, qemu, Java and many
> > other programs loading non-free compiled code at the run time.
> 
> Wine is licenced under the terms of the LGPL.
> 
> ReactOS is licenced under the terms of the GPL with a licence 
> exception for runtime linking of non-free modules.
> 
> QEMU is licenced under the terms of the GPL with a licence exception for 
> runtime linking with libqemu.a.
> 
> GNU classpath (and libgcj) are licenced under the terms of the GPL with 
> a licence exception for runtime linking with it.
> 
> As you can see, all of the above explicitely address this issue.
> 
> The only program from your list that has a fishy licencing is mplayer.

Thanks for the detailed analysis!

Anyway, as far as I know, copyright covers copying of works, and dynamic
linking never creates anything suitable for copying.  The "derived work"
stays in memory, just like it does when a proprietary program runs on
top of the Linux kernel.  Memory dumps might be illegal to distribute
though.

I'm not a lawyer and the above is not a legal advice.  I don't represent
Free Software Foundation.

-- 
Regards,
Pavel Roskin
