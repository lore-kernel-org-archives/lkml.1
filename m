Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYAYF5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYAYF5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYAYF4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:56:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:39197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYAYF4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:56:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="371109522"
Subject: [PATCH 0/6] x86: some fixes of early_ioremap and EFI runtime
	services
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:54:50 +0800
Message-Id: <1201240490.15972.42.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:06.0902 (UTC) FILETIME=[B284B560:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes some bugs about early_ioremap and EFI runtime services.

This patchset is based on latest x86 git tree and has been tested on
EFI 32 and EFI 64 platform.

Best Regards,
Huang Ying

