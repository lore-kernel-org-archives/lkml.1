Return-Path: <linux-kernel-owner+w=401wt.eu-S972920AbXHMQpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972920AbXHMQpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971703AbXHMP6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:58:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58169 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971344AbXHMP6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:58:50 -0400
Message-ID: <46C07FAE.1040504@garzik.org>
Date: Mon, 13 Aug 2007 11:58:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain> <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <20070807001429.f8cb3b22.akpm@linux-foundation.org> <1186496712.3414.17.camel@localhost.localdomain> <46B88B91.4050703@garzik.org> <1186501124.3414.32.camel@localhost.localdomain> <20070807105144.0ba67d81.akpm@linux-foundation.org> <20070813124225.GT23758@kernel.dk>
In-Reply-To: <20070813124225.GT23758@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> #for-akpm is usually only in very few -mm release anyway, so it's not
> like it would have made much difference. We/you/I need to improve that,
> certainly.
> 
> Honestly, for bsg, it wasn't much of an issue. We had build problems
> when bsg was merged which was unfortunate but got fixed quickly. Having
> bsg in -mm would not have caused any testing of the driver in question
> outside of what it already received, given the nature of it.


That's just an excuse for what happened -- you made an end run around 
our test tree.  Pretty please with sugar on it -- make sure changes show 
up in -mm.

	Jeff


