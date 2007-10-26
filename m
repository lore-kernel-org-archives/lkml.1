Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbXJZQh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbXJZQh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbXJZQgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:33 -0400
Received: from waste.org ([66.93.16.53]:56555 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754681AbXJZQgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:31 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Message-Id: <1.430487409@selenic.com>
Subject: [PATCH 0/12] maps4: pagemap monitoring v4
Date: Fri, 26 Oct 2007 11:36:25 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is version 4 of my /proc/pid/pagemaps code.

Changes in this series:

- kpageflags decoupled from kernel internal flag bits (suggested by
  Dave Hansen)
- better docs for walk_page_range (suggested by Jeremy Fitzhardinge)
- a number of cleanups suggested by Dave Rientjes
- fixed kconfig (spotted by Rusty Russell)


