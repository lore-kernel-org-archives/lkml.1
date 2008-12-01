Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYLAQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYLAQdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYLAQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:33:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYLAQd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:33:26 -0500
Message-ID: <493411D0.2040507@redhat.com>
Date: Mon, 01 Dec 2008 11:33:20 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 08/11] memcg: make zone_reclaim_stat
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081201211646.1CE2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081201211646.1CE2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> introduce mem_cgroup_per_zone::reclaim_stat member and its statics collecting
> function.
> 
> Now, get_scan_ratio() can calculate correct value although memcg reclaim.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
