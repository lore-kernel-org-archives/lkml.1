Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZBJK7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZBJK7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZBJK7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:59:37 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57125 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZBJK7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:59:36 -0500
Date: Tue, 10 Feb 2009 16:29:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: remove mem_cgroup_calc_mapped_ratio()
Message-ID: <20090210105931.GD16317@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090210184249.6FCD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090210184249.6FCD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-02-10 18:45:33]:

> 
> Currently, mem_cgroup_calc_mapped_ratio() is unused at all.
> it can be removed and KAMEZAWA-san suggested it.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
