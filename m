Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbZIWMnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbZIWMnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZIWMnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:43:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:41517 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZIWMni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190735390"
Message-Id: <20090923123337.990689487@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 23 Sep 2009 20:33:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jan Kara <jack@suse.cz>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] [RFC] writeback fixes for 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some writeback patches intended for 2.6.32,
they are based on the latest linux-next plus Jara's
busy loop fix.

They are mostly bug fixes. The last patch is a behavior change
that should be optional for 2.6.32, but included for review.

Thanks,
Fengguang

