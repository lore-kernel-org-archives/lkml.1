Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZKRIeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZKRIeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZKRIeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:34:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:27526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZKRIby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830421"
Message-Id: <20091118082648.140755818@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/12] trivial writeback cleanups/fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some trivial writeback cleanups and fixes for .33.

They are all independant ones (don't rely on each other),
and can be pulled either by Andrew/Jens, or by individual
filesystem maintainers.

Thanks,
Fengguang

