Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbYDWBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbYDWBlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbYDWBl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:41:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49442 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729AbYDWBl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:41:26 -0400
Date: Wed, 23 Apr 2008 10:45:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Shi Weihua <shiwh@cn.fujitsu.com>, balbir@linux.vnet.ibm.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] Fix usemap initialization v2
Message-Id: <20080423104511.3148a126.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0804221106250.12316@blonde.site>
References: <20080418161522.GB9147@csn.ul.ie>
	<48080706.50305@cn.fujitsu.com>
	<48080930.5090905@cn.fujitsu.com>
	<48080B86.7040200@cn.fujitsu.com>
	<20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
	<21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
	<20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0804211250000.16476@blonde.site>
	<20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0804221106250.12316@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 11:12:59 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 22 Apr 2008, KAMEZAWA Hiroyuki wrote:
> > Tested on ia64/2.6.25
> >    DISCONTIGMEM + 16KB/64KB pages
> >    SPARSEMEM    + 16KB/64KB pages
> > seems no troubles.
> > 
> > Thanks,
> > -Kame
> 
> Looks good to me, if Mel and Shi approve.  (Well, there are two typos,
> "creted" should be "created" and "migratetpye" should be "migratetype".)
> 
Ouch...I'll fix.

Thanks,
-Kame

