Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbZIPK3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbZIPK3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZIPK3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:29:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:4140 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZIPK3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224398"
Message-Id: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] page-types tool updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are some updates for page-types. The first 2 patches 
are trivial additions of the KSM and HWPOISON bits, which
should be OK for .32.

The latter patches are mainly code refactors (no behavior change)
plus one final patch for adding the hwpoison/unpoison feature.
They are tested OK, but could delay merging them if necessary.

Thanks,
Fengguang
-- 

