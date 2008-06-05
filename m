Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYFET0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYFET0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFET0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:26:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40787 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750924AbYFET0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:26:05 -0400
Date: Thu, 5 Jun 2008 14:25:56 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] genirq: Expose default irq affinity mask (take 3)
Message-Id: <20080605142556.61c30cbc.pj@sgi.com>
In-Reply-To: <484421E6.30709@qualcomm.com>
References: <1212084172-21459-1-git-send-email-maxk@qualcomm.com>
	<20080602102340.71d2399f.pj@sgi.com>
	<484421E6.30709@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last week, Max wrote:
> btw What's the procedure for including Acked-by ?

If the acked-by comes fairly shortly after the original
patch, and isn't excessively buried in a bunch of discussion,
then Andrew will catch it, and add it to the patch in his
queue.

If you have to resubmit the patch anyway, then of course,
add the acked-by then.

If neither of the above applies, and the acked-by is lost,
but your patch is successfully applied anyway, then either of
  (1) if you're feeling lazy, don't worry about it, or
  (2) reply again to that lkml thread, being sure akpm is on
      the cc list, asking Andrew to add the acked-by.

Andrew is the expert, of course, in such matters.

If he says something contrary to the above, ignore me.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
