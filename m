Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYLAQbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYLAQbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYLAQbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:31:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYLAQbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:31:44 -0500
Message-ID: <49341165.2020206@redhat.com>
Date: Mon, 01 Dec 2008 11:31:33 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 07/11] memcg: make mem_cgroup_zone_nr_pages()
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081201211545.1CDF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081201211545.1CDF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> introduce mem_cgroup_zone_nr_pages().
> it is called by zone_nr_pages() helper function.
> 
> 
> this patch doesn't have any behavior change.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
