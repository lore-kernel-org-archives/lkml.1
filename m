Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbYDDARU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbYDDARU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbYDDAQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:16:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:33234 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760814AbYDDAQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,600,1199692800"; 
   d="scan'208";a="312483103"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n - Apple
Date: Thu, 3 Apr 2008 17:14:22 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com>
In-Reply-To: <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n - Apple
Thread-Index: AciV6BB0/ns1Je/vQvKHWbj34qQrBAAAHwXQ
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: <Pallipadi@ogre.sisk.pl>, "Soeren Sonnenburg" <kernel@nn7.de>
X-OriginalArrivalTime: 04 Apr 2008 00:12:05.0332 (UTC) FILETIME=[83A02140:01C895E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
>Sent: Thursday, April 03, 2008 4:23 PM
>To: Linux Kernel Mailing List
>Cc: Pallipadi@ogre.sisk.pl; Pallipadi, Venkatesh; Soeren Sonnenburg
>Subject: 2.6.25-current-git hangs on boot unless 
>CONFIG_CPU_IDLE=n - Apple
>
>The following report is on the current list of known regressions
>from 2.6.24.  Please verify if the issue is still present in the
>mainline.
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
>Subject		: 2.6.25-current-git hangs on boot 
>unless CONFIG_CPU_IDLE=n - Apple
>Submitter	: Soeren Sonnenburg <kernel@nn7.de>
>Date		: 2008-02-23 18:55 (41 days old)
>References	: http://lkml.org/lkml/2008/2/23/263
>		  
>http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
>Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>

Last comment I saw from Soeren says it does not really hang. It waits
for 5-10 seconds sometimes before continuing. We are still trying to
narrow this down with max_cstate etc..

Thanks,
Venki
