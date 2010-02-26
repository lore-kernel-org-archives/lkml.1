Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363Ab0BZLoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:44:54 -0500
Received: from home.kolivas.org ([59.167.196.135]:59853 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935157Ab0BZLow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:44:52 -0500
From: Con Kolivas <kernel@kolivas.org>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: 2.6.33-ck1
Date: Fri, 26 Feb 2010 22:20:26 +1100
User-Agent: KMail/1.12.4 (Linux/2.6.33-ck1; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002262220.26534.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any workload.


Apply to 2.6.33:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.33/2.6.33-
ck1/patch-2.6.33-ck1.bz2

Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.33/2.6.33-
ck1/2.6.33-ck1-broken-out.tar.bz2

Web:
http://kernel.kolivas.org

all patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Full patch list:

2.6.33-sched-bfs-315.patch
sched-add-above-background-load-function.patch
mm-make_swappiness_really_mean_it.patch
mm-kswapd_inherit_prio.patch
mm-background_scan.patch
mm-idleprio_prio.patch
mm-lru_cache_add_lru_tail.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
ck-version.patch

Each separate patch has a brief summary of its purpose in the patch itself.

-- 
-ck
