Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZGaBlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZGaBlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 21:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZGaBlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 21:41:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:47348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZGaBlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 21:41:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,298,1246863600"; 
   d="scan'208";a="170795488"
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v5 0/4] x86: MCE: testing enhancement
Date: Fri, 31 Jul 2009 09:41:39 +0800
Message-Id: <1249004503-17254-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

This patchset is necessary for MCE regression testing suite mce-test 
(http://www.kernel.org/pub/scm/utils/cpu/mce/mce-test.git) to work 
properly.

This version is rebased on x86-tip.git/mce

Best Regards,
Huang Ying
