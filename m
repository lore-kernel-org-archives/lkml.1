Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXJBOdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXJBOdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXJBOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:33:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60448 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbXJBOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:33:04 -0400
Date: Tue, 2 Oct 2007 15:37:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [50/50] x86_64: Remove fpu io port resource
Message-ID: <20071002153740.5c77922f@the-village.bc.nu>
In-Reply-To: <4700DA44.8020706@garzik.org>
References: <200709221231.836138000@suse.de>
	<20070921223251.1312913DCD@wotan.suse.de>
	<46F44D27.4050704@garzik.org>
	<200710011240.35802.ak@suse.de>
	<4700DA44.8020706@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Oct 2007 07:30:12 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Andi Kleen wrote:
> > So far I still maintain i386 and x86-64. If Thomas wants to take both
> > over completely he can do that; but I won't bother handling any patches i didn't 
> > write then anymore.
> 
> 
> What does that mean?
> 
> Didn't we all agree that x86 and x86-64 are going to be merged?
> 
> If yes, isn't it logical to avoid patches that extend the separation?
> 
> This is just basic playing-well-with-others fundamentals.

No Andi is right - he didn't agree. He made it clear he didn't agree and
even at the kernel summit from what he said I'd assumed this meant from
2.6.24 we'd simply have a different maintainer team for x86-32/64.

We all (except Andi) agreed it was going to be merged and Andi made his
position clear - Thomas and Ingo just need to update the MAINTAINERS file
and get on with it.

Alan
