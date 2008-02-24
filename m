Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYBXI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYBXI0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 03:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYBXI0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 03:26:02 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:37253 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYBXI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 03:26:00 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang 
In-reply-to: <200802240012.36571.bzolnier@gmail.com> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080222213932.3403F93C12F@tippex.mynet.homeunix.org> <20080223221721.5C8502DC002@tippex.mynet.homeunix.org> <200802240012.36571.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Sun, 24 Feb 2008 00:12:36 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 24 Feb 2008 09:25:47 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080224082547.84F542DC002@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JTCBE-0000Qr-6o.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JTCBE-0000Qr-6o fb426345a27f1d6d88caeef7d9f60bff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
> Could you try bisecting it down to the guilty commit using git-bisect?
> [ the "old" stuff got few hundred commits in 2.6.25 ]
> Thanks, Bart 

Will do. It'll take a while though. Not a fast machine and used by the 
household...

/A

