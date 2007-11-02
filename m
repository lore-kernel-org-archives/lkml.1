Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXKBBBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXKBBBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXKBBBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:01:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:40058 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbXKBBBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:01:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,360,1188802800"; 
   d="scan'208";a="309970722"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
Date: Fri, 2 Nov 2007 09:01:31 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC295BE93@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20071031125907.ba953d4a.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/2 -v2 resend] x86_64 EFI boot support
Thread-Index: Acgb+LX5lE2JJL8/TOuijiCOb2+PUgA8upTw
References: <1193218342.23935.147.camel@caritas-dev.intel.com><1193793701.23935.394.camel@caritas-dev.intel.com> <20071031125907.ba953d4a.akpm@linux-foundation.org>
From: "Huang, Ying" <ying.huang@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
       <torvalds@linux-foundation.org>, <adaplas@pol.net>, <ak@suse.de>,
       <ebiederm@xmission.com>, <mouli@linux.intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Nov 2007 01:01:32.0272 (UTC) FILETIME=[E871BF00:01C81CEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andrew Morton [mailto:akpm@linux-foundation.org]
>On Wed, 31 Oct 2007 09:21:41 +0800
>"Huang, Ying" <ying.huang@intel.com> wrote:
>
>> Can this patchset be merged into mainline kernel? This patchset has
been
>> in -mm tree from 2.6.23-rc2-mm2 on. Andrew Moton has suggested it to
be
>> merged into 2.6.24 during early merge window of 2.6.24. It was not
>> merged into mainline because the 32-bit boot protocol has not been
done.
>>
>> But now, the 32-bit boot protocol has been merged into mainline. So
can
>> this patchset be merged into mainline kernel now?
>>
>
>I stopped paying attention, sorry.  Have all the outstanding issues
been
>addressed?

That's all right. I think there is no big issue with this patchset, just
a framebuffer driver and the document.

Best Regards,
Huang Ying
