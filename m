Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbYBVRzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbYBVRzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYBVRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:54:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:34655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYBVRyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:54:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,392,1199692800"; 
   d="scan'208";a="344218840"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 100% C0 with 2.6.25-rc
Date: Fri, 22 Feb 2008 09:55:36 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE9A967D@orsmsx423.amr.corp.intel.com>
In-Reply-To: <47BF0B65.3060900@willies.info>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 100% C0 with 2.6.25-rc
Thread-Index: Ach1e53ccl7ep+fKTFqYg33a761BbgAAG6MA
References: <47BD600F.9090502@willies.info> <200802211733.54759.rjw@sisk.pl> <47BEF0A6.9000405@willies.info> <924EFEDD5F540B4284297C4DC59F3DEE9A964C@orsmsx423.amr.corp.intel.com> <47BF0B65.3060900@willies.info>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Jan Willies" <jan@willies.info>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 22 Feb 2008 17:54:08.0109 (UTC) FILETIME=[EC02C1D0:01C8757B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jan Willies [mailto:jan@willies.info] 
>Sent: Friday, February 22, 2008 9:50 AM
>To: Pallipadi, Venkatesh
>Cc: Rafael J. Wysocki; linux-acpi@vger.kernel.org; Ingo 
>Molnar; LKML; Thomas Gleixner
>Subject: Re: 100% C0 with 2.6.25-rc
>
>Pallipadi, Venkatesh wrote:
>> One question. Do you have CONFIG_CPU_IDLE enabled in your confg?
>
>Yes, I have. Attached is my .config file
>

Can you try with it disabled and check whether you still see the
problem?

Thanks,
Venki
