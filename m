Return-Path: <linux-kernel-owner+w=401wt.eu-S1763873AbZFLLFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763873AbZFLLFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZFLLFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:05:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41289 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbZFLLFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:05:43 -0400
Date: Fri, 12 Jun 2009 13:05:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612110536.GN18682@elf.ucw.cz>
References: <20090611140038.GB11199@atomide.com> <20090611140624.GS795@n2100.arm.linux.org.uk> <alpine.LFD.2.00.0906111314510.31536@xanadu.home> <4A3175AC.9070100@bluewatersys.com> <alpine.LFD.2.00.0906112105220.31536@xanadu.home> <4A31AECA.6070303@bluewatersys.com> <alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com> <20090612103521.GD18682@elf.ucw.cz> <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-12 03:44:21, Brian Swetland wrote:
> On Fri, Jun 12, 2009 at 3:35 AM, Pavel Machek<pavel@ucw.cz> wrote:
> >>
> >> My hope with the msm support is to get buildable, bootable (we're
> >> there now), style-clean (we probably have stuff that needs help yet,
> >
> > I still can't get it to boot :-(.
> 
> I think the cupcake userspace and the latest 2.6.29 kernel aren't
> getting along.  I'm putting together instructions for building a
> minimal userspace (what we call tiny android -- and what I use for
> bringup and kernel testing), and once I've had a chance to verify that
> everything works end-to-end with the latest kernel, donut branch, and
> have verified this on ADP1, I'll send an update.  Probably some time
> over the weekend.

Ok, I just got 2.6.29 to boot. It seems that fastboot really needs
zImage, and thet one needs to be patient when staring at rainbow
screen.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
