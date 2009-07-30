Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbZG3Iw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbZG3Iw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZG3Iw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:52:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:36728 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZG3Iw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:52:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,294,1246863600"; 
   d="scan'208";a="479226446"
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v4 0/4] x86: MCE: testing enhancement
Date: Thu, 30 Jul 2009 16:52:29 +0800
Message-Id: <1248943953-26100-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

This patchset is necessary for MCE regression testing suite mce-test 
(http://www.kernel.org/pub/scm/utils/cpu/mce/mce-test.git) to work 
properly.

Best Regards,
Huang Ying
