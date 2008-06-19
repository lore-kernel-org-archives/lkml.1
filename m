Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYFSJiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYFSJiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYFSJiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:38:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42072 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYFSJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:38:05 -0400
Date: Thu, 19 Jun 2008 18:38:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 0/5] memory related bugfix set for 2.6.26-rc5-mm3 
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080619183230.E814.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

the mailing list manager of linux-mm dropped "From:" line 
at beginning of the mail ;)

the patches are writed by below person.
please pay attention.

1/5 fix munlock page table walk
	-> From: Lee Schermerhorn <lee.schermerhorn@hp.com>
2/5 migration_entry_wait fix.
	-> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
3/5 collect lru meminfo statistics from correct offset
	-> From: Lee Schermerhorn <lee.schermerhorn@hp.com>
4/5 fix incorrect Mlocked field of /proc/meminfo.
	-> Hugh Dickins <hugh@veritas.com>
5/5 putback_lru_page()/unevictable page handling rework
	-> From: KAMEZAWA Hiroyuki <kamezawa.hiroy@jp.fujitsu.com>



> Hi, Andrew and -mm guys!
> 
> Unfortunately, linux-2.6.26-rc5-mm3 has several bugs and 
> some bugs depend on each other.
> 
> thus, I collect, sort, and fold these patchs..
> this patchset surve on my stress workload >5H.
> 
> enjoy!



