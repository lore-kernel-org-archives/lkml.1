Return-Path: <linux-kernel-owner+w=401wt.eu-S936365AbZDJGRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936365AbZDJGRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934086AbZDJGQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:28520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677AbZDJGQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013408"
Message-Id: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:09:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 0/9] filemap and readahead fixes for linux-next
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This is the original patchset minus the fault retry ones,
rebased onto next-20090409.

Thanks,
Fengguang
-- 

