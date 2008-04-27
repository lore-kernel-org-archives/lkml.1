Return-Path: <linux-kernel-owner+w=401wt.eu-S1764124AbYD0Tew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764124AbYD0Tew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763337AbYD0TeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:34:11 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:40108 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763283AbYD0TeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:34:09 -0400
Message-ID: <4814D459.1020602@linux.vnet.ibm.com>
Date: Mon, 28 Apr 2008 01:00:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, Mel Gorman <mel@csn.ul.ie>,
       Shi Weihua <shiwh@cn.fujitsu.com>, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] Fix usemap initialization v3
References: <20080418161522.GB9147@csn.ul.ie> <48080706.50305@cn.fujitsu.com> <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com> <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com> <21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com> <20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0804211250000.16476@blonde.site> <20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com> <20080423134621.6020dd83.kamezawa.hiroyu@jp.fujitsu.com> <20080427121817.03b432ca.akpm@linux-foundation.org>
In-Reply-To: <20080427121817.03b432ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Do we think this is needed in 2.6.25.x?

My answer would be yes. Shi reproduced this problem with 2.6.25

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
