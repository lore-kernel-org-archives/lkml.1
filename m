Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXGIKHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXGIKHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXGIKG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:06:56 -0400
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:37508 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315AbXGIKG4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:06:56 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: 2.6.22-ck1
Date: Mon, 9 Jul 2007 20:06:49 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Message-Id: <200707092006.49316.kernel@kolivas.org>
X-Length: 2336
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-ck1 is the last ever -ck release.

So long, and thanks for all the fish


This patchset is designed to improve system responsiveness and interactivity. 
It is configurable to any workload but the default -ck patch is aimed at the 
desktop and -cks is available with more emphasis on serverspace.


Apply to 2.6.22
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.22/2.6.22-ck1/patch-2.6.22-ck1.bz2

or server version
http://www.kernel.org/pub/linux/kernel/people/ck/patches/cks/patch-2.6.22-cks1.bz2

web:
http://kernel.kolivas.org

wiki:
http://ck.wikia.com

all patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Full patch list:

sched-staircase-deadline-cpu-scheduler.patch
sched-range.patch
sched-iso-5.5.patch
track_mutexes-1.patch
sched-idleprio-2.4.patch
sched-limit_policy_changes.patch
sched-ck-add-above-background-load-function.patch
cfq-ioprio_inherit_rt_class.patch
cfq-iso_idleprio_ionice.patch
mm-swap_prefetch-41.patch 
mm-convert_swappiness_to_mapped.patch
mm-lots_watermark.diff
mm-kswapd_inherit_prio-1.patch 
mm-prio_dependant_scan-2.patch
mm-background_scan-2.patch
mm-filesize_dependant_lru_cache_add.patch
mm-idleprio_prio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch 
hz-no_default_250.patch 
hz-raise_max-2.patch
ck-desktop-tune.patch
ck-final-version.patch


さようなら、いままで魚をありがとう

-- 
-ck
