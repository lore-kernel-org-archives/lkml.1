Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZK0Lgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZK0Lgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZK0Lgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:36:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:14708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbZK0Lgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:36:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271302"
Message-Id: <20091127105908.944744141@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:08 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/6] trivial writeback cleanups/fixes V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some independant writeback cleanups/fixes for 2.6.33.

Comparing to V2, it fixes some gcc warnings and removed
the ones merged in individual fs trees and the patch for bdi_stat_sum().

Thanks,
Fengguang

