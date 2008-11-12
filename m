Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYKLDeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYKLDeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYKLDd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:33:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39597 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYKLDd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:33:58 -0500
Date: Wed, 12 Nov 2008 12:33:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 0/6] memcg updates (12/Nov/2008)
Message-Id: <20081112123315.3edcc39f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 12:26:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Weekly updates on my queue.
> 
> Changes from previous (05/Nov)
>  - added "free all at rmdir" patch.
>  - fixed several bugs reported by Nishimura (Thanks!)
>  - many style bugs are fixed.
> 
> Brief description:
> [1/6].. free all at rmdir (and add attribute to memcg.)
> [2/6].. handle swap cache
> [3/6].. mem+swap controller kconfig
> [4/6].. swap_cgroup
> [5/6].. mem+swap controller
> [6/6].. synchrinized LRU (unify lru lock.)
> 
> I think it's near to a month to test this mem+swap controller internally.
> It's getting better. Making progress in step by step works good.
> 
> I'll send [1/6] and [2/6] to Andrew, tomorrow or weekend.(please do final check).
> 
> If no acks to [1/6] (I haven't got any ;), I'll postpone it and reschedule as [7/6].
> 
Ah, sorry. 
All are based on "The mm-of-the-moment snapshot 2008-11-10-14-54".


Thanks,
-Kame

