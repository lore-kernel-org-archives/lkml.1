Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbYAaHfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbYAaHfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYAaHfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:35:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:38467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYAaHfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:35:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="255960183"
Subject: [PATCH 0/5] x86: ioremap and change_page_attr fixes
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 15:35:56 +0800
Message-Id: <1201764956.12950.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 07:34:54.0603 (UTC) FILETIME=[C5B525B0:01C863DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds executable mapping support to ioremap, fixes some
issue of change_page_attr and early_ioremap, and fixes EFI memory
mapping accordingly.

This patchset is based on latest x86 git tree and has been tested on
EFI 32 and EFI 64 platform.

Best Regards,
Huang Ying

