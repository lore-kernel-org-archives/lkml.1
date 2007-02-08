Return-Path: <linux-kernel-owner+w=401wt.eu-S1422758AbXBHPsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758AbXBHPsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423068AbXBHPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:48:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55137 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422758AbXBHPsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:48:16 -0500
Date: Thu, 8 Feb 2007 16:48:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Oleg Verych <olecom@flower.upol.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid using spaces in call arguments
Message-ID: <20070208154817.GA18083@uranus.ravnborg.org>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 03:52:54PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 8 Feb 2007, Roman Zippel wrote:
> > 
> > Sorry, it needs more changes, the patch simply wasn't ready.
> 
> One problem I find very problematic with all the Kbuild setup is that 
> people tend to be very quiet about any build issues until they simply go 
> in.
> 
> Things don't "get ready" on their own. In other areas, people comment on 
> why they don't like patches. In Kbuild, for some reason, we often seem to 
> have this situation where people don't react at all.
> 
> Sam is great about maintaining the kernel build stuff most of the time, 
> but because it's clearly a "secondary" thing, there tends to be some 
> periods when nothing happens. Which is problematic for me..
Sorry about my silence for now three months.
Been overly busy and with family now extended to three kids takes time too.

I will be back in a months time - maybe a bit sooner.
As for the Kbuild area I usual have patches cooking in -mm for a while
before pushing to you - comments are usual few when I post patches
which I take as a sign that most people do not care about Kbuild
as long as it works, other are not into the makefile trickery,
and also that the patches are small logical steps (which is
true for all contributions and not just mine).

	Sam
