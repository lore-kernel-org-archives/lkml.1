Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXJBPbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXJBPbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXJBPb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:31:29 -0400
Received: from www.tglx.de ([62.245.132.106]:57962 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbXJBPb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:31:28 -0400
Date: Tue, 2 Oct 2007 17:30:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <20071002145806.GA3567@uranus.ravnborg.org>
Message-ID: <alpine.LRH.0.999.0710021728060.23586@www.tglx.de>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <alpine.LRH.0.999.0710021250510.23586@www.tglx.de> <20071002140711.GA29395@elte.hu>
 <200710021623.09966.ak@suse.de> <20071002143115.GA4867@elte.hu>
 <20071002145806.GA3567@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Tue, 2 Oct 2007, Sam Ravnborg wrote:
> Hi Andi/Ingo.
> 
> I plan to integrate cflags-probe in kbuild.git if there is no objection.
> And I will address any x86 issues when I do so.
> On top of that I will most likely do the same change for i386.

Makes sense. While you are at it, can you please have an eye on the
Build system changes I did to make arch/x86 with the two stub
directories arch/i386 and arch/x86_64 work.

Thanks,

	tglx

