Return-Path: <linux-kernel-owner+w=401wt.eu-S1032341AbXEHVWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032341AbXEHVWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032333AbXEHVWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:22:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:50040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032185AbXEHVWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:22:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,507,1170662400"; 
   d="scan'208";a="85072384"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
Date: Tue, 8 May 2007 14:22:01 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F55DF62B@scsmsx415.amr.corp.intel.com>
In-Reply-To: <200705090008.00916.caglar@pardus.org.tr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
thread-index: AceRtQnar+qx0pquQjmAER27sbXRtwAAbM+Q
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <caglar@pardus.org.tr>
CC: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Wright" <chrisw@sous-sol.org>
X-OriginalArrivalTime: 08 May 2007 21:22:02.0002 (UTC) FILETIME=[EB3C4720:01C791B6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: S.Çaðlar Onur [mailto:caglar@pardus.org.tr] 
>Sent: Tuesday, May 08, 2007 2:08 PM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel; Andrew Morton; Thomas Gleixner; Andi Kleen; 
>Ingo Molnar; Chris Wright
>Subject: Re: [PATCH 1/8] Restructuring hpet timer generic 
>clock interfaces
>
>08 May 2007 Sal tarihinde, Pallipadi, Venkatesh þunlarý yazmýþtý: 
>> Hmm. Looks like timer was somehow not set correctly.
>> Can you try only the first 5 patches in the patchset and 
>leave out the last
>> three and check whether it works.
>
>Yep, first 5 patches works fine,
>

That's good news :-).

Can you send me the full dmesg with the 5 patches and also the config file you are using. Also, did you try these patches against 2.6.21-vanilla or recent git?

Thanks,
Venki
