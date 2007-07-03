Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbXGCQnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbXGCQnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXGCQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:43:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093AbXGCQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:43:15 -0400
Date: Tue, 3 Jul 2007 09:42:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <20070703173429.24b5dbdc@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0707030941280.9434@woody.linux-foundation.org>
References: <20070703155238.GA7344@havoc.gtf.org> <20070703170734.5a25b9c5@the-village.bc.nu>
 <alpine.LFD.0.98.0707030919391.9434@woody.linux-foundation.org>
 <20070703173429.24b5dbdc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jul 2007, Alan Cox wrote:
>
> > attribution. Probably because of some insane system he uses (he has a 
> > comment in that bugzilla about "patch from comment #14 is in CVS now.".
> > 
> > CVS? What kind if insane setup do you have there at Red Hat?
> 
> CVS is used for tracking patch sets for RPMS rather than source trees.
> Its quite good at that job and its reliable and proven and has been done
> that way for years. When you are keeping a stable distribution for large
> business end users the "stable and proven" wins over new technology...

Yes, but it also explains why it lost all authorship. 

So instead of complaining to Jeff about this, you should look at YOUR OWN 
damn system. It was apparently your "enterprise ready" stuff, used by 
another Red Hat engineer, that screwed up.

THAT is my point.

			Linus
