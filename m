Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbXH1T5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbXH1T5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbXH1T5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:57:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:13721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbXH1T53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:57:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,318,1183359600"; 
   d="scan'208";a="289581042"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
Date: Tue, 28 Aug 2007 12:57:27 -0700
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A4031EF65B@orsmsx415.amr.corp.intel.com>
In-Reply-To: <200708272353.09380.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
thread-index: AcfpAz2rfKW1Q6+WQJKGN6eGg/3X+wAqhlmw
References: <200708272347.45438.rjw@sisk.pl> <200708272353.09380.rjw@sisk.pl>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "pm list" <linux-pm@lists.linux-foundation.org>
X-OriginalArrivalTime: 28 Aug 2007 19:57:27.0885 (UTC) FILETIME=[A91777D0:01C7E9AD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since these changes appear to affect the ACPICA core in a fairly big
way, I would like to see a short, concise description of each change and
why it is necessary.

Thanks,
Bob


-----Original Message-----
From: linux-acpi-owner@vger.kernel.org
[mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
Sent: Monday, August 27, 2007 2:53 PM
To: Andrew Morton
Cc: ACPI Devel Maling List; Len Brown; LKML; Pavel Machek; pm list
Subject: [PATCH -mm 3/3] PM: Improve handling of ACPI system state
indicator (rev. 3)

From: Rafael J. Wysocki <rjw@sisk.pl>
