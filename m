Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbYKLEAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbYKLEAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYKLEA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:00:29 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48380 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYKLEA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:00:29 -0500
Message-ID: <491A54D5.4030006@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 09:30:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 0/6] memcg updates (12/Nov/2008)
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
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

Sorry, I have not looked at the patches yet, I am busy with the hierarchy
patches and number extraction.

-- 
	Balbir
