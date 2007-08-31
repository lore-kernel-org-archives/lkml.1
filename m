Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXHaFeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXHaFeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXHaFe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:34:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354AbXHaFe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:34:27 -0400
Date: Thu, 30 Aug 2007 22:34:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] ACPI: EC: Check if boot_ec was really found in DSDT
Message-Id: <20070830223418.70958a58.akpm@linux-foundation.org>
In-Reply-To: <46D7A723.9080002@suse.de>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
	<20070829232150.GA17467@dreamland.darkstar.lan>
	<200708301907.56561.daniel.ritz-ml@swissonline.ch>
	<alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
	<46D7A196.7070309@suse.de>
	<alpine.LFD.0.999.0708302220490.25853@woody.linux-foundation.org>
	<46D7A723.9080002@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 09:29:07 +0400 Alexey Starikovskiy <astarikovskiy@suse.de> wrote:

> Linus Torvalds wrote:
> > On Fri, 31 Aug 2007, Alexey Starikovskiy wrote:
> >   
> >> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> >>     
> >
> > This was totally whitespace-damaged. You have some broken email client 
> > that turns <tab>s into four spaces.
> >
> > May I suggest rethinking the use of Thunderbird (aka "mangles things 
> > ridiculously")?
> >
> > Anyway, I fixed it up and applied it.
> >
> > 		Linus
> >   
> Thanks, what client do you use/recommend?
> 

I use sylpheed.  thunderbird can be used, but one needs to follow
the steps in http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
to get it out of i-know-better mode.
