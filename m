Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZAHJ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZAHJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZAHJ1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:27:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36190 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZAHJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:27:00 -0500
Date: Thu, 8 Jan 2009 18:25:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: [RFC][PATCH] cgroup and memcg updates 20090108
Message-Id: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request for comments for 4 cgroup/memcg patches.
 
 [1/4] CSS ID support for cgroup
    minor update from the last year.

 [2/4] use CSS ID in memcg
    minor update

 [3/4] fix oom-kill problem of memcg/hierarchy=1
    minor update, but I'm still looking for better fix.

 [4/4] fix frequest -EBUSY at rmdir().
     New one. I need advices.

I'd like to remove RFC of some of them in the next week.

Thanks,
-Kame

