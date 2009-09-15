Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZIOCZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZIOCZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbZIOCY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:24:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:35908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZIOCY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:24:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,386,1249282800"; 
   d="scan'208";a="187622967"
Message-Id: <20090915021851.168285585@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Sep 2009 10:18:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <clameter@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

Here are 3 more kmem patches in my queue. Comments are welcome.
If you feel good about them, I can send all recent kmem cleanup
patches for you.

Thanks,
Fengguang
-- 

