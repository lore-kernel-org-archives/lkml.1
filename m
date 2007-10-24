Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbXJXLtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbXJXLtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXJXLsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:48:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55825 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXJXLsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:48:53 -0400
Message-ID: <471F311D.8010302@garzik.org>
Date: Wed, 24 Oct 2007 07:48:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024113043.GA11897@elte.hu>
In-Reply-To: <20071024113043.GA11897@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Linus, please pull the latest x86 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> it contains two build fixes and an oops-printout-ugliness fix.

Any chance you can kill the warnings that appear on !CONFIG_SMP, 
!LOCAL_APIC ?  :)

http://marc.info/?l=linux-kernel&m=119317911305274&w=2
http://marc.info/?l=linux-kernel&m=119317911105258&w=2

It is /likely/ that my fixes are not upstream-worthy, these patches 
mainly illustrate the problem, not necessarily the best solution.

	Jeff



