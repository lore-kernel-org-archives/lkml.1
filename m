Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbXGCQ2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbXGCQ2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbXGCQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:28:33 -0400
Received: from [81.2.110.250] ([81.2.110.250]:42739 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759416AbXGCQ2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:28:31 -0400
Date: Tue, 3 Jul 2007 17:34:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
Message-ID: <20070703173429.24b5dbdc@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0707030919391.9434@woody.linux-foundation.org>
References: <20070703155238.GA7344@havoc.gtf.org>
	<20070703170734.5a25b9c5@the-village.bc.nu>
	<alpine.LFD.0.98.0707030919391.9434@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> attribution. Probably because of some insane system he uses (he has a 
> comment in that bugzilla about "patch from comment #14 is in CVS now.".
> 
> CVS? What kind if insane setup do you have there at Red Hat?

CVS is used for tracking patch sets for RPMS rather than source trees.
Its quite good at that job and its reliable and proven and has been done
that way for years. When you are keeping a stable distribution for large
business end users the "stable and proven" wins over new technology...

Alan
