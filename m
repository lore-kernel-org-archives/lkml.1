Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZIIBQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZIIBQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZIIBQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:16:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59736 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZIIBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:16:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Sep 2009 10:14:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Message-Id: <20090909101446.4cf3f373.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090909094529.0CD6.A69D9226@jp.fujitsu.com>
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
	<20090909094529.0CD6.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Sep 2009 09:49:15 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> This release doesn't boot on my ia64 test box.
> After following two patches reverted, booting was successful.
> 
> 	page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch 
> 	Kamezawa-san's kcore patch series
> 
> 
> Mel, Kamezawa-san, Can you please gime me any advise?
> 
> 

Kosaki-san, could you give me your .config ?

Thanks,
-Kame
> 
> 
> 

