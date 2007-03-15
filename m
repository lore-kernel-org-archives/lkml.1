Return-Path: <linux-kernel-owner+w=401wt.eu-S1422936AbXCOQLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936AbXCOQLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422938AbXCOQLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:11:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46277 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422936AbXCOQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:11:13 -0400
X-Originating-Ip: 74.108.131.3
Date: Thu, 15 Mar 2007 12:08:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Kumar Gala <galak@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] PPC: Delete unused header file.
In-Reply-To: <Pine.LNX.4.64.0703150955440.23053@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703151205350.10198@localhost.localdomain>
References: <Pine.LNX.4.64.0703101616060.27495@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.64.0703150955440.23053@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_XP 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Kumar Gala wrote:

> On Sat, 10 Mar 2007, Robert P. J. Day wrote:
>
> >
> >   Delete apparently unused header file
> > arch/powerpc/platforms/83xx/mpc834x_itx.h.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
>
> applied.
>
> In the future it would be helpful if you also copied the linuxppc-dev list
> on ppc patches.

ok, but can you clarify the proper list of recipients for each patch?
if the MAINTAINERS file lists one or more individual maintainers *and*
one or more mailing lists, should *all* of them be CCed on a patch?
what's the rule here?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
