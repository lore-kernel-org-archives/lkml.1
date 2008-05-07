Return-Path: <linux-kernel-owner+w=401wt.eu-S1763489AbYEGWK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763489AbYEGWK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762432AbYEGWJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:09:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:58519 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbYEGWJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="243516691"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Date: Wed, 7 May 2008 15:12:21 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com>
In-Reply-To: <482217F3.2040900@numericable.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Thread-Index: AciwhRxb3GhV4E5lRy6EwPB/8LmfZwAChioA
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rufus & Azrael" <rufus-azrael@numericable.fr>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 22:09:46.0510 (UTC) FILETIME=[0F6442E0:01C8B08F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
>Sent: Wednesday, May 07, 2008 1:58 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
>Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>xf86MapVidMem error
>
>Pallipadi, Venkatesh a écrit :
>>  
>>
>> Yes. This has some debug information in there. Did you see 
>xf86MapVidMem error (I mean did you try to start X) before you 
>captured this dmesg?
>>
>> Thanks,
>> Venki
>>
>>   
>Hi all,
>
>Yes, the error's message is in my Xorg.log file :-)
>

One more piece of data I need. Can you please send the output of `cat /proc/mtrr` from this system (after the X failure has happened)

Thanks,
Venki
