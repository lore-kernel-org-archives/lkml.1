Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYGPR4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYGPR4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYGPR4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:56:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:25605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYGPR4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:56:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,198,1215414000"; 
   d="scan'208";a="315873303"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Dropping WUSB/UWB from my patch queue
Date: Wed, 16 Jul 2008 10:55:43 -0700
Message-ID: <C72DEB015BA7724783363DE1AF6B0F98053E11A0@orsmsx417.amr.corp.intel.com>
In-Reply-To: <487E317C.9040409@csr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Dropping WUSB/UWB from my patch queue
Thread-Index: Acjnan5XK7wvgAvoRSGnwxsuIc1c6gAAnUkg
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com> <487CE2E7.90505@csr.com> <20080716054911.GA9806@kroah.com> <487DC4FA.4050505@csr.com> <C72DEB015BA7724783363DE1AF6B0F9805393C24@orsmsx417.amr.corp.intel.com> <487E317C.9040409@csr.com>
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "David Vrabel" <david.vrabel@csr.com>
Cc: "Greg KH" <greg@kroah.com>, "linux-usb" <linux-usb@vger.kernel.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jul 2008 17:56:21.0550 (UTC) FILETIME=[4171FCE0:01C8E76D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: David Vrabel [mailto:david.vrabel@csr.com]
>
>Perez-Gonzalez, Inaky wrote:
>>> From: David Vrabel [mailto:david.vrabel@csr.com]
>>>
>>> Postponed:
>>>
>>> * HWA radio controller driver
>>> * Wire Adapter core (for HWAs and DWAs).
>>> * HWA host controller
>>> * WLP support
>>> * i1480 firmware download driver.
>>> * i1480 WLP driver.
>>
>> If I got you a fix for the USB reset stuff, would you be able to
merge
>> these guys?
>
>That would be appreciated.  I just don't have the time to tackle tricky
>problems with wired USB devices.

I'll see what I can do -- the trip to OLS can be useful for having a 
straight set of ours for patching the kernel, away from the distractions
of work.

