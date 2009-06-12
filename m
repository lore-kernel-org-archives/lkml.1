Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbZFLKkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbZFLKkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZFLKkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:40:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57533 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755275AbZFLKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:40:12 -0400
Date: Fri, 12 Jun 2009 11:40:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, Nicolas Pitre <nico@cam.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, David Miller <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612114055.3579ad92@lxorguk.ukuu.org.uk>
In-Reply-To: <20090612103521.GD18682@elf.ucw.cz>
References: <20090611132134.GA11199@atomide.com>
	<20090611133736.GP795@n2100.arm.linux.org.uk>
	<20090611140038.GB11199@atomide.com>
	<20090611140624.GS795@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.0906111314510.31536@xanadu.home>
	<4A3175AC.9070100@bluewatersys.com>
	<alpine.LFD.2.00.0906112105220.31536@xanadu.home>
	<4A31AECA.6070303@bluewatersys.com>
	<alpine.LFD.2.00.0906112138090.31536@xanadu.home>
	<a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
	<20090612103521.GD18682@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> > - is it essential to completely flatten down to single patches for new
> > drivers?  We do have history including contributions from Qualcomm,
> > HTC, etc, which would be nice to preserve in some cases, but if that's
> > impractical, we can do a complete rebase and flatten on top of tip of
> > tree.
> 
> I guess preserving history is not top priority.

Preserving the history is very important if it contains things like
authorship data. If you are feeding a git tree into the kernel then its
probably best to keep it in that format all the way to Linus.

Alan
