Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXJBKig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXJBKig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXJBKi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:38:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39613 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbXJBKi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:38:26 -0400
Message-ID: <47021F83.4070609@garzik.org>
Date: Tue, 02 Oct 2007 06:37:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org > <alpine.LRH.0.999.0710021019310.23586@www.tglx.de> <200710021121.36443.ak@suse.de>
In-Reply-To: <200710021121.36443.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 02 October 2007 11:17:02 Thomas Gleixner wrote:
>>> This is also a good time to warn about the fact that we're doing the x86 
>>> merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
>>> have pending patches for the next series that touch arch/i386 or x86-64, 
>>> you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
>>> keepers of the merge scripts, and will help you prepare..
> 
> 
> Yes I have ~100 patches for arch/x86_64, arch/i386
> 
> Should I just drop them?

Why don't you work with Thomas and Ingo to make sure everything is in 
sync and prepped for 2.6.24?

	Jeff



