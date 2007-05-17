Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXEQKKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXEQKKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXEQKKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:10:24 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:43976 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbXEQKKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:10:24 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/5] Annotation fixes for grouping pages by mobility v2
Date: Thu, 17 May 2007 11:10:22 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V1
o Added Acks from Christoph Lameter

Hi Andrew,

The following patches deal with annotation fixups and clarifications on
GFP flag usage only. In particular, the last patch in this set fixes the
issue with grow_dev_page() using __GFP_RECLAIMABLE that was brought up
yesterday. Please merge.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
