Return-Path: <linux-kernel-owner+w=401wt.eu-S1767233AbXEBTFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767233AbXEBTFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767254AbXEBTFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:05:10 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:57013 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767233AbXEBTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:05:09 -0400
Date: Wed, 2 May 2007 15:05:08 -0400
To: Martin Mares <mj@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Message-ID: <20070502190508.GI5577@csclub.uwaterloo.ca>
References: <463698D5.20102@zytor.com> <46369A8F.1050809@garzik.org> <46369B03.1060500@zytor.com> <mj+md-20070502.074425.20911.nikam@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mj+md-20070502.074425.20911.nikam@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:46:07AM +0200, Martin Mares wrote:
> > I mean the SVGA chip-specific code.
> 
> Feel free to kill it, anybody using these cards is very unlikely to run
> a 2.6.x kernel.
> 
> However, the BIOS mode switching is still useful.

I have a 486 with a Mach64 in it running 2.6.18, so well, it just might
happen you know.  I do tend to run it plain 80x25 at the moment, but
that is mainly because it is just doing firewall duties.  I never was
very impressed by the mach64 fb driver when I played with it years ago,
and vesa isn't an option on that card (needed a DOS TSR to do that).

Not sure if that card is covered by any of the chip specific code.

So what is wrong with a 15 year old machine when it has 48MB ram and
18GB disk space?

--
Len Sorensen
