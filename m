Return-Path: <linux-kernel-owner+w=401wt.eu-S965660AbXBOL2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbXBOL2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965898AbXBOL2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:28:37 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55152 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660AbXBOL2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:28:34 -0500
Message-ID: <45D443DF.8010102@garzik.org>
Date: Thu, 15 Feb 2007 06:28:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unify pcspeaker platform device code between i386/x86-64
References: <200702150901.l1F910lp023036@hera.kernel.org> <45D4299D.6000906@garzik.org> <200702151049.57943.ak@suse.de> <20070215111920.GC8353@redhat.com>
In-Reply-To: <20070215111920.GC8353@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, Feb 15, 2007 at 10:49:57AM +0100, Andi Kleen wrote:
>  > 
>  > > It's always seemed broken (though perhaps this was a distro bug?) in 
>  > > module form, so I've been compiling it in to get it to work.
>  > 
>  > Must have been a distro bug. It should have worked before as long 
>  > as the config was enabled.
> 
> If so, I'm not sure what distro Jeff was running, as it worked
> fine in Fedora for some time on both 32bit and 64bit x86 for me.

Fedora's always had this problem for me, on most if not all the active 
computers in my lab :)  Maybe my house is over a magetic ley line or 
something :)

	Jeff




