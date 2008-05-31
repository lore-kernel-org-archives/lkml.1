Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYEaBzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYEaBzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbYEaBzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:55:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36725 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbYEaBzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:55:08 -0400
Message-ID: <4840AFF1.8050003@pobox.com>
Date: Fri, 30 May 2008 21:54:57 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 5] xen device driver updates [resend]
References: <patchbomb.1212192090@localhost>
In-Reply-To: <patchbomb.1212192090@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi,
> 
> [ Repost spelling Jeff's email addr properly. ]
> 
> This is a series of cleanups to xen-blkfront, xen-netfront and xenbus.
> They're mostly changes imported from the linux-2.6.18-xen repo because
> they looked like they would be useful.
> 
> Thanks,
> 	J
> 
>  drivers/block/xen-blkfront.c       |   48 ++++++++++++++++++++++++++---
>  drivers/net/xen-netfront.c         |    4 +-
>  drivers/xen/xenbus/xenbus_client.c |    2 -
>  drivers/xen/xenbus/xenbus_xs.c     |   10 +++---
>  4 files changed, 52 insertions(+), 12 deletions(-)

I presume most of these should have been "To: Jens"?  The drivers/net/ 
is really the only thing under my direct purview.

Comments to follow...

	Jeff


