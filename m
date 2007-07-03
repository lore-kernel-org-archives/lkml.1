Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXGCQW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXGCQW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXGCQWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:22:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755799AbXGCQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:22:18 -0400
Date: Tue, 3 Jul 2007 09:21:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <20070703170734.5a25b9c5@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0707030919391.9434@woody.linux-foundation.org>
References: <20070703155238.GA7344@havoc.gtf.org>
 <20070703170734.5a25b9c5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jul 2007, Alan Cox wrote:
>
> > Chuck Ebbert (1):
> >       pata_ali: fix UDMA settings
> 
> Could you please fix your git tree to have the proper credits for patches
> you pull from bugzilla. 
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242472

I don't think it is Jeff who needs to fix anything: it seems that it is 
Chuck Ebbert you should talk to. He's the one that dropped the 
attribution. Probably because of some insane system he uses (he has a 
comment in that bugzilla about "patch from comment #14 is in CVS now.".

CVS? What kind if insane setup do you have there at Red Hat?

			Linus
