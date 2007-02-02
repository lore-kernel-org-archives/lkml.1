Return-Path: <linux-kernel-owner+w=401wt.eu-S1161144AbXBBOu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161144AbXBBOu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXBBOu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:50:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:27284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161144AbXBBOuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:50:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,273,1167638400"; 
   d="scan'208"; a="42332378:sNHT19074861"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.20-rc6-mm3
Date: Fri, 2 Feb 2007 17:50:44 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC7CC863@mssmsx411>
In-Reply-To: <45C34F08.90307@fr.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.20-rc6-mm3
Thread-Index: AcdG2R4+t0gy4FqTQ2uTl5ckFYYE5QAAB72Q
From: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Cc: "Andrew Morton" <akpm@osdl.org>, <linux-kernel@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       "keith mannthey" <kmannth@us.ibm.com>
X-OriginalArrivalTime: 02 Feb 2007 14:50:53.0860 (UTC) FILETIME=[89E3BE40:01C746D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>so it probably means that drivers/acpi/tables/tbxfroot.c is
>obsolete ?
Yes.
>
>> Could you please try it?
>
>sure, I'll cancel the current boot test in which I was using
>acpi_find_root_pointer() in tbxfroot.c and restart one with your
>new patch. I should have the result today.
How long does it take to boot this thing?
Regards,
	Alex.
