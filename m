Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYAJUxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYAJUxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYAJUxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:53:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:11757 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbYAJUxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:53:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="493692545"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 11/11] PAT x86: Expose uc and wc interfaces in /sysfsvor pci_mmap_resource
Date: Thu, 10 Jan 2008 12:54:15 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A28D7@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080110194306.GA21357@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 11/11] PAT x86: Expose uc and wc interfaces in /sysfsvor pci_mmap_resource
Thread-Index: AchTwQwjBMJv+wyoTZGtDjouQ8jpzAACd2wA
References: <20080110184840.927409000@intel.com> <20080110184856.859264000@intel.com> <20080110194306.GA21357@suse.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <ak@muc.de>, <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <arjan@infradead.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 20:53:22.0019 (UTC) FILETIME=[D613F330:01C853CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Greg KH [mailto:gregkh@suse.de] 
>Sent: Thursday, January 10, 2008 11:43 AM
>To: Pallipadi, Venkatesh
>Cc: ak@muc.de; ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; airlied@skynet.ie; 
>davej@redhat.com; mingo@elte.hu; tglx@linutronix.de; 
>hpa@zytor.com; akpm@linux-foundation.org; arjan@infradead.org; 
>Barnes, Jesse; davem@davemloft.net; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 11/11] PAT x86: Expose uc and wc 
>interfaces in /sysfsvor pci_mmap_resource
>
>On Thu, Jan 10, 2008 at 10:48:51AM -0800, 
>venkatesh.pallipadi@intel.com wrote:
>> New interfaces exported for uc and wc accesses. Apps has to 
>change to use
>> these new interfaces.
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
>Please update the documentation for this change, as well as adding
>something to Documentation/ABI/ for these new sysfs files.
>

OK. Will do.

Thanks,
Venki
