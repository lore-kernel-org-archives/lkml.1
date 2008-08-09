Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYHIHVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYHIHVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYHIHUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:20:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37068 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYHIHUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:20:53 -0400
Date: Sat, 9 Aug 2008 08:20:31 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080809072031.GB25046@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <20080731182315.GA18060@linux-mips.org> <20080809025244.GB9794@uranus.ravnborg.org> <20080809030927.GA7766@linux-sh.org> <20080809070344.GA11302@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809070344.GA11302@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 09:03:44AM +0200, Sam Ravnborg wrote:
> On Sat, Aug 09, 2008 at 12:09:28PM +0900, Paul Mundt wrote:
> > Where was this discussed? SH has the same issues obviously, but we've
> > already settled on a scheme.
> 
> Looking again I realize this was only discussed on the arm kernel mailing list
> and people involved was rmk, Harvaard and myself.

... and with almost every other ARM person ignoring it entirely, except
for them posting patches against the old layout, and asking when they're
going to be merged.

It was plainly obvious that almost no one was reading Sam's "[RFC pseudo
PATCH] migrate to arch/arm/include" thread.

So it might as well have been discussed here out of their sight. :(

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
