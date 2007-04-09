Return-Path: <linux-kernel-owner+w=401wt.eu-S966116AbXDIQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966116AbXDIQOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966123AbXDIQOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:14:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:13814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116AbXDIQOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:14:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="70780005:sNHT19899270"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21-rc6-mm1
Date: Mon, 9 Apr 2007 09:14:19 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com>
In-Reply-To: <200704091808.23417.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21-rc6-mm1
thread-index: Acd6wOM91L7KikRWQ4Gndl1fIuikEQAAOrhw
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <randy.dunlap@oracle.com>,
       <lenb@kernel.org>, "Adam Belay" <abelay@novell.com>
X-OriginalArrivalTime: 09 Apr 2007 16:14:20.0981 (UTC) FILETIME=[21A14650:01C77AC2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
>Sent: Monday, April 09, 2007 9:08 AM
>To: Andrew Morton
>Cc: linux-kernel@vger.kernel.org; randy.dunlap@oracle.com; 
>lenb@kernel.org; Pallipadi, Venkatesh
>Subject: Re: 2.6.21-rc6-mm1
>
>On Sunday, 8 April 2007 23:35, Andrew Morton wrote:
>> 
>> 
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
>.6.21-rc6/2.6.21-rc6-mm1/
>> 
>> 
>> - Lots of x86 updates
>> 
>> - This is a 25MB diff against mainline, which is rather large.
>
>The cpuidle thing tends to hang my x86-64 machines on boot.
>

Hi Rafael,

At what point during boot does it hang? Can you send me the last few
messages before the hang. And full dmesg when cpuidle is not configured
will help as well.

Thanks,
Venki
