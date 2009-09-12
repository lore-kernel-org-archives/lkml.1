Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZILPYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZILPYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZILPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:24:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:44692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZILPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:24:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186918796"
Message-Id: <20090912152039.479536123@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:20:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] more /dev/[k]mem cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are three more devmem cleanup patches following your comments.

Thanks,
Fengguang
-- 

