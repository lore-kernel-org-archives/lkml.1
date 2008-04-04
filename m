Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYDDGgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYDDGgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYDDGgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:36:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:19649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbYDDGgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,602,1199692800"; 
   d="scan'208";a="545524243"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n -Apple
Date: Thu, 3 Apr 2008 23:38:15 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEED0EB0B@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1207290744.4511.3.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n -Apple
Thread-Index: AciWHdmnC9FuHVRuQaaTA6D5wUtfAAAAHPTw
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.AOB.6GW9HB@albercik> <1207290744.4511.3.camel@localhost>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Apr 2008 06:36:08.0961 (UTC) FILETIME=[2AB2DF10:01C8961E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Soeren Sonnenburg [mailto:kernel@nn7.de] 
>Sent: Thursday, April 03, 2008 11:32 PM
>To: Rafael J. Wysocki
>Cc: Linux Kernel Mailing List; Pallipadi@ogre.sisk.pl; 
>Pallipadi, Venkatesh
>Subject: Re: 2.6.25-current-git hangs on boot unless 
>CONFIG_CPU_IDLE=n -Apple
>
>On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
>> The following report is on the current list of known regressions
>> from 2.6.24.  Please verify if the issue is still present in the
>> mainline.
>> 
>> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
>> Subject		: 2.6.25-current-git hangs on boot 
>unless CONFIG_CPU_IDLE=n - Apple
>> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
>> Date		: 2008-02-23 18:55 (41 days old)
>> References	: http://lkml.org/lkml/2008/2/23/263
>> 		  http://marc.info/?l=linux-acpi&m=120387537018467&w=4
>> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>
>yes still there, but not a hangs forever hang anymore but only a hang
>for (this time) 15 seconds hang.
>

Can you please try the max_cstate experiments that I mentioned in the
bugzilla.

Thanks,
Venki
