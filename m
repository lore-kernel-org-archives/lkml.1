Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZCYAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZCYAF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZCYAFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:05:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:45310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZCYAFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:05:11 -0400
Date: Tue, 24 Mar 2009 17:05:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324170559.1667c847@infradead.org>
In-Reply-To: <20090324160353.06a4a5ed@hobbes.virtuouswap>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324132032.GK5814@mit.edu>
	<20090324160353.06a4a5ed@hobbes.virtuouswap>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 16:03:53 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> 
> I remember early in the 2.6.x days there was a lot of focus on making
> interactive performance good, and for a long time it was.  But this
> I/O problem has been around for a *long* time now... What happened?
> Do not many people run into this daily?  Do all the filesystem
> hackers run with special mount options to mitigate the problem?
> 

the people that care use my kernel patch on ext3 ;-)
(or the userland equivalent tweak in /etc/rc.local)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
