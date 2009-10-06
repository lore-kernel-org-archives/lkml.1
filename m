Return-Path: <linux-kernel-owner+w=401wt.eu-S933501AbZJFWS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbZJFWS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933292AbZJFWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:18:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47871
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933201AbZJFWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:18:51 -0400
Date: Tue, 06 Oct 2009 15:18:46 -0700 (PDT)
Message-Id: <20091006.151846.145117006.davem@davemloft.net>
To: peterz@infradead.org
Cc: mingo@elte.hu, paulus@samba.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Provide vmalloc() based mmap() backing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1254830228.21044.272.camel@laptop>
References: <1254830228.21044.272.camel@laptop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 06 Oct 2009 13:57:08 +0200

> Dave, I preserved your ACK, since you don't seem to care about the
> particular form, as long as the problem gets solved. Feel free to kick
> me if I got that wrong ;-)

That's perfectly fine, thanks!
