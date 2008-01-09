Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbYAIC5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbYAIC5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYAIC50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:57:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:53746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYAIC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:57:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,260,1196668800"; 
   d="scan'208";a="280838303"
Subject: [PATCH -mm 0/2] kexec/i386: kexec page table code clean up
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 10:57:42 +0800
Message-Id: <1199847462.8126.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 09 Jan 2008 02:56:53.0257 (UTC) FILETIME=[49C33F90:01C8526B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up page table setup code of kexec on i386.

This patchset is based on 2.6.24-rc5-mm1 and has been tested on i386
with/without PAE enabled.

Best Regards,
Huang Ying

