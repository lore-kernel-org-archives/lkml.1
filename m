Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbXKBBDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbXKBBDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXKBBC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:02:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:3601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbXKBBC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,360,1188802800"; 
   d="scan'208";a="365560528"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
Date: Fri, 2 Nov 2007 09:02:47 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC295BE97@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <4728E0DE.7080702@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
Thread-Index: Acgb+jWwCmyYPuiXRxewdbiLKnrj5wA8bUbg
References: <1193218342.23935.147.camel@caritas-dev.intel.com>	<1193793701.23935.394.camel@caritas-dev.intel.com> <20071031125907.ba953d4a.akpm@linux-foundation.org> <4728E0DE.7080702@zytor.com>
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <tglx@linutronix.de>, <mingo@redhat.com>, <torvalds@linux-foundation.org>,
       <adaplas@pol.net>, <ak@suse.de>, <ebiederm@xmission.com>,
       <mouli@linux.intel.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Nov 2007 01:02:47.0737 (UTC) FILETIME=[156CCA90:01C81CEC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: H. Peter Anvin [mailto:hpa@zytor.com]
>The "EFI boot" patchset looks fairly unobtrusive to me.  One objection:
>the VIDEO_TYPE_ numbers appear split up into groups; and the EFI one
>probably should be 0x70 instead of 0x24.

Should I change this and resend the patchset? Or you modify it before
merging?

Best Regards,
Huang Ying
