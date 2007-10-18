Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbXJRMga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbXJRMga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXJRMgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:36:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56501
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756643AbXJRMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:36:22 -0400
Date: Thu, 18 Oct 2007 05:36:36 -0700 (PDT)
Message-Id: <20071018.053636.21618957.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071018121547.GY5063@kernel.dk>
References: <20071018.050554.115911163.davem@davemloft.net>
	<20071018120950.GX5063@kernel.dk>
	<20071018121547.GY5063@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 18 Oct 2007 14:15:47 +0200

> On Thu, Oct 18 2007, Jens Axboe wrote:
> > On Thu, Oct 18 2007, David Miller wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Date: Thu, 18 Oct 2007 13:57:02 +0200
> > > 
> > > > Thanks a lot, Dave! The patch is a monster right now, I'll work on
> > > > splitting it into a 3-step process. Any arch help is greatly
> > > > appreciated.
> > > 
> > > I have some other bits that my compile hit, such as some things in the
> > > crypto layer.
> > 
> > Yeah, I have tons of that so far. I hope to have an allyesconfig
> > compiling pretty soonish, will send that out then.
> 
> OK here goes, this compiles with allyesconfig on x86-64. Not too bad,
> the scsi/ drivers were by far the worst.

It build cleanly here on sparc64 too.

It's late and I'm about to hit bed so I'm too chicken to do a test
boot it right now :-)

