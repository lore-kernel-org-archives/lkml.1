Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZEPJHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZEPJHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZEPJG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:06:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:54714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZEPJG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,204,1241420400"; 
   d="scan'208";a="143509888"
Message-Id: <20090516090005.916779788@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 16 May 2009 17:00:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: [PATCH 0/3] make mapped executable pages the first class citizen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patchset makes mapped executable pages the first class citizen.
This version has incorparated many valuable comments from people in
the CC list, and runs OK on my desktop. Let's test it in your -mm?

Thanks,
Fengguang
-- 

