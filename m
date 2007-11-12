Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXKLFWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXKLFWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 00:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXKLFWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 00:22:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53710 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXKLFWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 00:22:16 -0500
Date: Mon, 12 Nov 2007 06:23:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] introduce K64BIT=y and backward compatibility ARCH={i386,x86_64} for x86
Message-ID: <20071112052355.GA15826@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <Pine.LNX.4.64.0711120344310.1818@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711120344310.1818@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 03:47:02AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Sat, 10 Nov 2007, Sam Ravnborg wrote:
> 
> > As discussed in another thread the right thing is to add a generic solution
> > to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.
> 
> Could you please point me to this discussion?

It starts with this post from Jeff Garzik:
http://lkml.org/lkml/2007/11/9/274

	Sam
