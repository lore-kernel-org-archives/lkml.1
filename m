Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYLARKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYLARKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYLARKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:10:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42296 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYLARKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:10:09 -0500
Message-ID: <49341A66.3080905@redhat.com>
Date: Mon, 01 Dec 2008 12:09:58 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 09/11] memcg: remove mem_cgroup_calc_reclaim()
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081201211742.1CE5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081201211742.1CE5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Now, get_scan_ratio() return correct value although memcg reclaim.
> Then, mem_cgroup_calc_reclaim() can be removed.
> 
> So, memcg reclaim get the same capability of anon/file reclaim balancing as global reclaim now.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
