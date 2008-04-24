Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYDXXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYDXXvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYDXXvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:51:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:7679 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYDXXvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:51:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="556827782"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [git pull] ia64 changes
Date: Thu, 24 Apr 2008 16:51:01 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012F9EF0@orsmsx424.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git pull] ia64 changes
Thread-Index: AcimZgz9x7sJhzyHQ0m9vHmOVE9plg==
From: "Luck, Tony" <tony.luck@intel.com>
To: <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>, "Russ Anderson" <rja@sgi.com>
X-OriginalArrivalTime: 24 Apr 2008 23:51:04.0150 (UTC) FILETIME=[0E93C760:01C8A666]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release

This will update the files shown below. Both changes touch kernel/sched.c
to fix regressions ... one for a build problem, the other for a boot
problem.

Thanks!

-Tony

 kernel/sched.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

Mike Travis (1):
      Build fix for CONFIG_NUMA=y && CONFIG_SMP=n

Russ Anderson (1):
      [IA64] fix bootmem regression on Altix



