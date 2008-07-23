Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYGWTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYGWTI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYGWTIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbYGWTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:08:18 -0400
Date: Wed, 23 Jul 2008 12:08:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] MMC updates for 2.6.27-rc1
In-Reply-To: <20080723150031.36e5b85a@mjolnir.drzeus.cx>
Message-ID: <alpine.LFD.1.10.0807231206230.4754@woody.linux-foundation.org>
References: <20080719015911.02faddf6@mjolnir.drzeus.cx> <20080723150031.36e5b85a@mjolnir.drzeus.cx>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jul 2008, Pierre Ossman wrote:
>
>  include/linux/scatterlist.h |   38 +++++++
>  lib/scatterlist.c           |  176 +++++++++++++++++++++++++---------
> 
> Tejun Heo (1):
>       sg: reimplement sg mapping iterator

I'd really have been a lot happier about this one if it had had a few 
Acked-by's from people like Jens and James.

But I pulled, and pushed out. I think Jens is on vacation, but I'm adding 
him to the cc anyway.

		Linus
