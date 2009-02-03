Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZBCJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZBCJEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZBCJEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:04:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35778 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZBCJEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:04:32 -0500
Date: Tue, 3 Feb 2009 18:03:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 0/6] memcg/cgroup, updates related to CSS ID
Message-Id: <20090203180320.9f29aa76.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is CSS ID series of patches. Some are for cgroup, others are for memcg.

No big changes from previous version. (*) is a patch for cgroup.
I think almost all comments are satisfied.
Isn't it not so bad time to start to test something new ?

[1/6] CSS ID for cgroup (*)
[2/6] use CSS ID in memcg's hierarchy.
[3/6] hierarchical stat for memcg
[4/6] fix shrink memory retry or -EBUSY
[5/6] fix oom killer under memcg hierarchy.
[6/6] fix frequent -EBUSY (*)

Thanks,
-Kame

