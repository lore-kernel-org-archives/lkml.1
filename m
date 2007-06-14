Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbXFNLXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbXFNLXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXFNLWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:22:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58402 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXFNLWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:22:53 -0400
Date: Thu, 14 Jun 2007 13:23:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kbuild-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Need opinions on asm-offsets cleanup (Re: [patch 01/03] kbuild, asm-values: infrastructure)
Message-ID: <20070614112356.GB31634@uranus.ravnborg.org>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.648949000@flower.upol.cz> <20070614074143.GK7266@flower.upol.cz> <20070614091225.GA30817@uranus.ravnborg.org> <20070614111621.GL7266@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614111621.GL7266@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:16:21PM +0200, Oleg Verych wrote:
> On Thu, Jun 14, 2007 at 11:12:25AM +0200, Sam Ravnborg wrote:
> > On Thu, Jun 14, 2007 at 09:41:43AM +0200, Oleg Verych wrote:
> > > Jun 13, 2007 at 01:36:51AM +0200, asm-values patch set:
> > > > 	* header with widely used value definitions
> > > > 	* handle all asm-related things in one file (Makefile.asm)
> > > > 	* move some asm bits from Makefile.build there
> > > > 	  (rule %.s:%.c)
> > > > 	* add script to generate headers from assembles output
> > > > 	  (hopefully better output, MIPS testing/joining to all arch
> > > > 	   probably needed)
> > > > 
> > > > rfc-by: Oleg Verych
> > > > ---
> > > 
> > > So, is it another not so juicy lets-break-it-all stuff from me, or it just
> > > doesn't apply for you?
> > 
> > I have not yet looked at it. A few other items pending that I need to finish
> > off before next merge window has priority.
>  
> That's my view about asm-offsets cleanup/generalizing. I just need ack or
> nack from, for example arch maintainers if this is acceptable at all or
> anybody, actually interested in this kind of things. Not cool stuff, but
> still quite straight and easy to finish and merge.
I will for sure take a look.
But with less than 1 hour/day for Linux stuff this has been scheduled after
other stuff I need to do before next merge window.

	Sam
