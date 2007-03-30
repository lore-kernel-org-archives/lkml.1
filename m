Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbXC3UVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbXC3UVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXC3UVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:21:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:43342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbXC3UVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,354,1170662400"; 
   d="scan'208"; a="222346581:sNHT3076984337"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Date: Fri, 30 Mar 2007 13:21:03 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6E0100371E@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070330201017.GA21944@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Thread-Index: AcdzCH8cAr73KqhMR9OQiKPa/e9SiAAAFaxg
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 30 Mar 2007 20:21:04.0315 (UTC) FILETIME=[F0F948B0:01C77308]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote: 
> 
>> Perhaps we should put this into 2.6.22 then backport it to 
>2.6.21.x once it
>> seems safe to do so.  If we decide to go this way, we'll 
>need to ask Mitch
>> to remind us to do the backport at the appropriate time, 
>else we'll surely
>> forget.
>
>Yes, that's what I just asked him to do a message ago :)
>
Be happy to -- just give me a good definition of "appropriate
time".

-Mitch
