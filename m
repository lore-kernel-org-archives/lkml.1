Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXHWBAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXHWBAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXHWA7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:59:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:31002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbXHWA7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,296,1183359600"; 
   d="scan'208";a="120489514"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Git Patch] ACPI: Fix a warning of discarding qualifiers from pointer target type
Date: Wed, 22 Aug 2007 20:59:48 -0400
Message-ID: <CFF307C98FEABE47A452B27C06B85BB603A760AD@hdsmsx411.amr.corp.intel.com>
In-Reply-To: <20070821154750.GC21089@ftp.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Git Patch] ACPI: Fix a warning of discarding qualifiers from pointer target type
Thread-Index: AcfkCqqfKjJakSMtR1GnxR7EcpL7SgBFbsdw
References: <20070821132038.GA22254@ff.dom.local> <20070821150714.GA7591@hacking> <46CB0169.7090207@suse.de> <20070821151820.GB21089@ftp.linux.org.uk> <46CB034B.1070904@suse.de> <20070821154750.GC21089@ftp.linux.org.uk>
From: "Brown, Len" <len.brown@intel.com>
To: "Al Viro" <viro@ftp.linux.org.uk>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
Cc: "WANG Cong" <xiyou.wangcong@gmail.com>, "Jarek Poplawski" <jarkao2@o2.pl>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
X-OriginalArrivalTime: 23 Aug 2007 00:59:50.0887 (UTC) FILETIME=[E8AF5F70:01C7E520]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>On Tue, Aug 21, 2007 at 07:22:51PM +0400, Alexey Starikovskiy wrote:
>> Yes, that is the proper solution with a single drawback:
>> it touches ACPICA dual-licensed code and would take ages to commit,
>> and Len would probably ask you to give permission to 
>re-license it under
>> BSD.
>
>The latter is certainly not a problem (assuming that it's non-trivial
>enough to be copyrightable, in the first place).

The dual license is at the top of the file.
I just need to know when you touch one of these dual-license files
that Intel has your permission to ship your change to folks we
send the same file to under the BSD-style non-GPL license.
eg. BSD, Solaris and HPUX uses this same ACPICA files -- though in a
different format.

I've actually never had anybody say no when I asked.
And I've had some people who play laywers on TV tell me
this is not strictly necessary, but other people who play laywers
on TV tell me it is best to ask, so I do.

thanks,
-Len
