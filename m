Return-Path: <linux-kernel-owner+w=401wt.eu-S934476AbXILNVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbXILNVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbXILNVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:21:25 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:54419
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757139AbXILNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:21:24 -0400
Date: Wed, 12 Sep 2007 06:21:02 -0700 (PDT)
Message-Id: <20070912.062102.116370922.davem@davemloft.net>
To: bunk@kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [-mm patch] make tcp_splice_data_recv() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070909202558.GZ3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070909202558.GZ3563@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 9 Sep 2007 22:25:58 +0200

> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> >  git-block.patch
> >...
> >  git trees
> >...
> 
> tcp_splice_data_recv() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I'll let Jens or similar pick this one up since it
obviously won't apply to my tree.

