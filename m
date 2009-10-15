Return-Path: <linux-kernel-owner+w=401wt.eu-S935173AbZJORTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173AbZJORTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZJORTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:19:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:40329 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbZJORTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,567,1249282800"; 
   d="scan'208";a="199387603"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Oct 2009 10:18:39 -0700
Subject: RE: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
Thread-Topic: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
Thread-Index: AcpNtKsPx/2UqFvrTriAKJfb/omSKAAAL02w
Message-ID: <8DD2590731AB5D4C9DBF71A877482A903AF66FAB@orsmsx509.amr.corp.intel.com>
References: <alpine.DEB.2.00.0910151226000.10075@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0910151226000.10075@p34.internal.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not aware of any workaround for the reboot problem on that particular board and do not have one of the boards myself.  I've forwarded the issue on to a list of people who may be able to help.  In the meantime have you tried re-flashing with the latest BIOS?

>-----Original Message-----
>From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
>Sent: Thursday, October 15, 2009 9:29 AM
>To: linux-kernel@vger.kernel.org
>Cc: Allan, Bruce W
>Subject: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
>Kernel still hangs upon reboot.
>
>Hello,
>
>Bruce, it looks like that is coming from here:
>http://www.intel.com/support/motherboards/desktop/sb/CS-008326.htm
>
>Is there any workaround for the reboot problem?
>http://www.gossamer-
>threads.com/lists/linux/kernel/1141848?do=post_view_threaded
>
>It looks like there was a similar bug on 965 motherboards, in which, Intel
>issued a BIOS update that fixed it:
>http://lkml.indiana.edu/hypermail/linux/kernel/0610.2/2215.html
>
>Is Intel aware of this-- is there any communication/channels a customer
>can utilize (besides LKML) to ask Intel about the status/ETA on a fix for
>this issue?
>
>Justin.
