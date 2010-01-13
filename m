Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091Ab0AMI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0AMI1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827Ab0AMI1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:27:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59208 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab0AMI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:27:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Jan 2010 17:24:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] [v2] memcg: add anon_scan_ratio to memory.stat file
Message-Id: <20100113172404.339b31dc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100113172143.B3E8.A69D9226@jp.fujitsu.com>
References: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
	<20100113172143.B3E8.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 17:22:37 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Changelog
>   since v1: cancel to remove "recent_xxx" debug statistics as bilbir's
>   mention
> 
> ===========================================
> 
> anon_scan_ratio feature doesn't only useful for global VM pressure
> analysis, but it also useful for memcg memroy pressure analysis.
> 
> Then, this patch add anon_scan_ratio field to memory.stat file too.
> 
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame

