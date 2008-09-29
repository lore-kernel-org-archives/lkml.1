Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYI2KNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYI2KNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 06:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYI2KM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 06:12:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51439 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYI2KM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 06:12:56 -0400
Date: Mon, 29 Sep 2008 19:19:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 0/4] memcg: ready-to-go series (was memcg update v6)
Message-Id: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cut out 4 patches from memcg update v5 series.
(Then, this is a part of v6)

I think we got some agreement on these 4.

please ack if ok.

[1/4] ...  account swap under lock
[2/4] ...  make page->mapping to be NULL before uncharge cache.
[3/4] ...  avoid accounting not-on-LRU pages.
[4/4] ...  optimize cpu stat

I still have 6 patches but it's under test and needs review and discussion.

Thanks,
-Kame

