Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbXIMVyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbXIMVyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXIMVyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:54:17 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:34901
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbXIMVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:54:16 -0400
Date: Thu, 13 Sep 2007 14:54:08 -0700 (PDT)
Message-Id: <20070913.145408.41633935.davem@davemloft.net>
To: gregkh@suse.de
Cc: oliver.pntr@gmail.com, kovedi@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070913144236.GE3309@suse.de>
References: <20070912.011103.41643890.davem@davemloft.net>
	<6101e8c40709130559l69b87211k763c70a90d3d8221@mail.gmail.com>
	<20070913144236.GE3309@suse.de>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Thu, 13 Sep 2007 07:42:36 -0700

> Are you asking for this patch to go into the 2.6.22-y tree?  If so,
> please send it to the stable@kernel.org address so we know to add it
> to the queue.

I'll do that after I land in Seattle in about 7 hours and
do some testing of the patch.
