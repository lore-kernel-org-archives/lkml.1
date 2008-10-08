Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYJHVgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYJHVgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYJHVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:36:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:8717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbYJHVgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:36:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,380,1220252400"; 
   d="scan'208";a="345608841"
Message-Id: <20081008210101.487661000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 08 Oct 2008 14:01:01 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, youquan.song@intel.com
Subject: [patch 0/4] tip, dmar: queued invalidation patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables queued invalidation for DMA-remapping. And as such
removes the quirk from the x2apic/interrupt-remapping patchset which
disables dma-remapping while enabling interrupt-remapping.

Patches are on top of -tip tree because of its interaction with
x2apic/interrupt-remapping patches in tip.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
-- 

