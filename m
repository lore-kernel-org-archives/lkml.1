Return-Path: <linux-kernel-owner+w=401wt.eu-S933653AbZJFWXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbZJFWXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933562AbZJFWTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47878
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933513AbZJFWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:06 -0400
Date: Tue, 06 Oct 2009 15:19:01 -0700 (PDT)
Message-Id: <20091006.151901.49147379.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, paulus@samba.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Provide vmalloc() based mmap() backing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091006122359.GA7614@elte.hu>
References: <1254830228.21044.272.camel@laptop>
	<20091006122359.GA7614@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 Oct 2009 14:23:59 +0200

> Dave, could you please test it on Sparc too? The Git coordinates are at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/urgent

I'll find some time to give it a spin, thanks!
