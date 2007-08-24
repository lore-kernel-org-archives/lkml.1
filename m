Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbXHXGfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbXHXGfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXHXGfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:35:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXHXGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:35:07 -0400
Date: Fri, 24 Aug 2007 12:17:57 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Hugh Blemings <hugh@blemings.org>
cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Cbe-oss-dev] [PATCH] PS3: Update MAINTAINERS
In-Reply-To: <20070824162508.78f10666.hugh@blemings.org>
Message-ID: <alpine.LFD.0.999.0708241210560.20322@enigma.security.iitk.ac.in>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708211500100.2774@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708211148040.6982@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708211605320.2774@enigma.security.iitk.ac.in>
 <20070824162508.78f10666.hugh@blemings.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Aug 2007, Hugh Blemings wrote:

> Hi Satyam, All,
> 
> > [PATCH] PS3: Update MAINTAINERS
> > 
> > Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org> is an
> > subscribers-only mailing list.
> > 
> > Signed-off-by: Satyam Sharma <satyam@infradead.org>
> >
> > [...]
> 
> As per recent discussions...
> 
> The list is moderated for SPAM prevention, messages from valid senders
> will be forwarded manually and their email added to the whitelist.
> 
> I've changed the list config so that it no longer generates the
> "subscriber-only" notification.

So ... if someone (!subscriber && !whitelisted) sends a message, it stays
put somewhere till you get to it and determine whether it is relevant or
not, and either (1) forward it on to the list if appropriate, or (2) drop
it if detected as spam. And no "notifications" are ever sent out to
genuine / well-meaning posters during this process. Right?

> On this basis I recommended the patch be NAKd so that people aren't put
> off copying the list where appropriate.

Fair enough, if my understanding (as mentioned above) is correct, then I
believe the patch achieved a greater purpose than what it was originally
sent out for!

Thanks,

Satyam
