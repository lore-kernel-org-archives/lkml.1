Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCEEp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCEEp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 23:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZCEEpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 23:45:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40887 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbZCEEpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 23:45:13 -0500
Date: Thu, 05 Mar 2009 10:16:09 +0530
From: Amit Kumar Sharma <amitsharma.9@samsung.com>
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
To: Kyungmin Park <kmpark@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: adrian.hunter@nokia.com, h.rohit@samsung.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <D8532CBD8C914BAC87A51AE8D5CE058C@sisodomain.com>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
X-RFC2646: Format=Flowed; Original
References: <20090303063605.GA30258@july>
 <20090303124948.dda294e5.akpm@linux-foundation.org>
 <49AE6907.1080702@nokia.com>
 <20090304085055.c9de6cbb.akpm@linux-foundation.org>
 <9c9fda240903041547x540899f9hd94cbf49baac660b@mail.gmail.com>
 <20090304155544.3bc3f337.akpm@linux-foundation.org>
 <9c9fda240903041943m483db3f4i3c40c6970ef16fce@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,
----- Original Message ----- 
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Andrew Morton" <akpm@linux-foundation.org>; "AMIT 
KUMARSHARMA" <amitsharma.9@samsung.com>
Cc: <adrian.hunter@nokia.com>; <h.rohit@samsung.com>; 
<linux-mtd@lists.infradead.org>; 
<linux-kernel@vger.kernel.org>
Sent: Thursday, March 05, 2009 9:13 AM
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support


> Hi,
>
> On Thu, Mar 5, 2009 at 8:55 AM, Andrew Morton 
> <akpm@linux-foundation.org> wrote:
>> On Thu, 5 Mar 2009 08:47:03 +0900
>> Kyungmin Park <kmpark@infradead.org> wrote:
>>
>>> I think we know the issues currently and then if the 
>>> device is opened,
>>> handle this one if required.
>>> How do you think?
>>
>> I think it would be prudent to fix the known problems 
>> now, rather
>> than having to go through and re-debug them later on.
>>
>> Bear in mind that people frequently copy old code when 
>> writing
>> new code, so these things tend to propagate, creating 
>> more work
>> later on.
>>
>
> Agree,
>
> To Amit,
>
> Could you fix it and send a patch please.
> Also can you reduce the left shift operation to resolve it 
> permanently
sure  i will send it ASAP.
>
> Thank you,
> Kyungmin Park 


