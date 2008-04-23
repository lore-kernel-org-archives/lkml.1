Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbYDWCSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbYDWCSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYDWCR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:17:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52493 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbYDWCRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:17:55 -0400
Message-ID: <480E9C2B.4060508@cn.fujitsu.com>
Date: Wed, 23 Apr 2008 10:17:15 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] Fix usemap initialization v2
References: <20080418161522.GB9147@csn.ul.ie> <48080706.50305@cn.fujitsu.com> <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com> <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com> <21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com> <20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0804211250000.16476@blonde.site> <20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0804221106250.12316@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804221106250.12316@blonde.site>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote::
> On Tue, 22 Apr 2008, KAMEZAWA Hiroyuki wrote:
>> Tested on ia64/2.6.25
>>    DISCONTIGMEM + 16KB/64KB pages
>>    SPARSEMEM    + 16KB/64KB pages
>> seems no troubles.
>>
>> Thanks,
>> -Kame
> 
> Looks good to me, if Mel and Shi approve.  (Well, there are two typos,
> "creted" should be "created" and "migratetpye" should be "migratetype".)

I will confirm Kamezawa-san's patch as soon as possible. Maybe this afternoon.

