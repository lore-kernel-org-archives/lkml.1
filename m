Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZF3JCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZF3JCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZF3JCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:02:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59977 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZF3JCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:02:44 -0400
Date: Tue, 30 Jun 2009 18:01:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: [PATCH 0/2] memcg: fix cgroup rmdir hang v3
Message-Id: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated from previous one.

 - Updated comments.
 - add cgroup_exclude_rmdir()/cgroup_release_rmdir().

Patch 1/2 is tested by Nishimura (look is modified but the same algorithm..)
Patch 2/2 is a new. but no difficulty.

Thank you for all your helps

Regards,
-Kame

