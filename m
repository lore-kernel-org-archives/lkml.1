Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbXJBPiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbXJBPiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXJBPip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:38:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46876 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbXJBPip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:38:45 -0400
Date: Tue, 2 Oct 2007 17:40:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002154013.GA3886@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <alpine.LRH.0.999.0710021250510.23586@www.tglx.de> <20071002140711.GA29395@elte.hu> <200710021623.09966.ak@suse.de> <20071002143115.GA4867@elte.hu> <20071002145806.GA3567@uranus.ravnborg.org> <alpine.LRH.0.999.0710021728060.23586@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0710021728060.23586@www.tglx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 05:30:27PM +0200, Thomas Gleixner wrote:
> Sam,
> 
> On Tue, 2 Oct 2007, Sam Ravnborg wrote:
> > Hi Andi/Ingo.
> > 
> > I plan to integrate cflags-probe in kbuild.git if there is no objection.
> > And I will address any x86 issues when I do so.
> > On top of that I will most likely do the same change for i386.

By the way - that patch depends on a few other patches in Andi's queue
but I will await until they are included.

> 
> Makes sense. While you are at it, can you please have an eye on the
> Build system changes I did to make arch/x86 with the two stub
> directories arch/i386 and arch/x86_64 work.
Thats on my TODO list - but I do not think I will find time before the merge.

	Sam
