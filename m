Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYJBGyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYJBGyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYJBGyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:54:01 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:31799 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753418AbYJBGyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:54:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kHup2cAYE4gLPY50tpQo9fA4hn0erQjR61WuC5TzDiU/sCwTS2Xk/VJjA5RHplxjIKr2F7sWdTIkVQY/1K/x7IUNQzzu1+9PM7Ii8JVydSIlyo7utLLWOjzJ7qdPwI0bOqCQmrCaX1y14dApVKjy9cMUhoOq41EXO2aHDjd0xxA=  ;
X-YMail-OSG: HBYazJYVM1n1aJTBRaZbQy8_A_U.aLZfeCEx1_O9dPKnxVF9pWYzplRcFNRjmUv_PghpbFdptP6N_jCyUq16H65pGLboV_N65x8XKSIkpNOKCCTJ4hKLREASnLxNG84o0ONpNVIuC1ma.DgLIBuQWn2y
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2.6.27-rc8 1/2] drivers/mfd/twl4030-core.c
Date: Wed, 1 Oct 2008 23:53:57 -0700
User-Agent: KMail/1.9.9
Cc: Samuel Ortiz <sameo@openedhand.com>, lkml <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-omap@vger.kernel.org
References: <200810011144.20510.david-b@pacbell.net> <200810011453.26699.david-b@pacbell.net> <20081002060521.GA7942@atomide.com>
In-Reply-To: <20081002060521.GA7942@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810012353.57753.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008, Tony Lindgren wrote:
> * David Brownell <david-b@pacbell.net> [081002 00:53]:
> > On Wednesday 01 October 2008, David Brownell wrote:
> > 
> > > NOTE: this is the current code from the linux-omap tree.
> > 
> > This chip being used on a whole bunch of boards:
> > 
> >  - Gumstix Overo
> >  - BeagleBoard.org
> >  - Omap ZOOM (Labrador)
> >  - OMAP 2430 and 3430 SDP,
> >  - OMAP2 and OMAP3 EVM
> >  - ... more (openpandora.org ?)

My bad.  Openpandora just opened for preorders *today* (PST)
and sold out all 3000 units.  I'm sure I mentioned it well
after most of them were sold, so it's not my fault their
server was killed.  Really ...


> > 
> > which will get much closer to "usable with mainline kernels"
> > when their power management chip works in mainline!  :)
> 
> Cool. I'll post some patches against mainline kernel
> for booting minimal omap3 boards within next few days.
> So we should get at least beagle and overo booting
> to some extent, maybe with serial and musb.

Sounds like it *should* be a nice, modest, achievable
goal, right?  Something tells me it won't be that easy!
More power to you.

- Dave

  
