Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbXGJSGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbXGJSGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbXGJSF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:05:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:4788 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099AbXGJSFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,523,1175497200"; 
   d="scan'208";a="248745665"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: -mm merge plans for 2.6.23 - ioat/dma engine
Date: Tue, 10 Jul 2007 11:05:45 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02A5736C@orsmsx418.amr.corp.intel.com>
In-Reply-To: <4693B47B.7050406@intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: -mm merge plans for 2.6.23 - ioat/dma engine
Thread-Index: AcfDD9UbHBJ5aB9jSQGQmNPFyhiUSgACyjsg
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 10 Jul 2007 18:05:46.0986 (UTC) FILETIME=[F0CDACA0:01C7C31C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote: 
>Andrew Morton wrote:
>> git-ioat-vs-git-md-accel.patch
>> ioat-warning-fix.patch
>> fix-i-oat-for-kexec.patch
>> 
>>  I don't seem to be able to get rid of these.  Chris Leech 
>appears to have
>>  vanished.
>
>Chris is a moving target. Thankfully we have Shannon Nelson 
>taking over Chris' 
>duties. Shannon, can you take a look at these and see what 
>needs to happen to it 
>? Most likely these just need to be pushed to the right person.

Auke: Thanks for the introduction :-).

Andrew: All three of these patches are reasonable and can be pushed on
up.  You can add my sign-off to all three:
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

>
>Cheers,
>
>Auke
>
>
>PS: I think we should add an I/OAT / DMA engine section in the 
>MAINTAINERS...
>

I'll be posting a MAINTAINERS patch Real Soon Now with my name on
IOAT/DMA.

sln
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
