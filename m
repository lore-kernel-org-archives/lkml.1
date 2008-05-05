Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYEEQ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYEEQ5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYEEQ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:57:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:6780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYEEQ5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,438,1204531200"; 
   d="scan'208";a="278049165"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 10:00:15 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEFB9204@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200805051855.05496.elendil@planet.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git head] Should X86_PAT really default to yes?
Thread-Index: Aciu0MfzNVl+IjJESEKg9UNEuapW4wAAJW7g
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <86802c440805041323s1484a8ecx5dbe639d658d015b@mail.gmail.com> <200805051855.05496.elendil@planet.nl>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Frans Pop" <elendil@planet.nl>, "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>, <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
X-OriginalArrivalTime: 05 May 2008 16:57:41.0800 (UTC) FILETIME=[21C4C280:01C8AED1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Frans Pop [mailto:elendil@planet.nl] 
>Sent: Monday, May 05, 2008 9:55 AM
>To: Yinghai Lu
>Cc: Barnes, Jesse; Pallipadi, Venkatesh; 
>linux-kernel@vger.kernel.org; Ingo Molnar; Packard, Keith
>Subject: Re: [git head] Should X86_PAT really default to yes?
>
>On Sunday 04 May 2008, Yinghai Lu wrote:
>> can you boot with pat=off and send out /proc/mtrr?
>
>Hmmm. Is 'pat=off' supposed to do anything?
>

The option for this is actually "nopat".

Thanks,
Venki
