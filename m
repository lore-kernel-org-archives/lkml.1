Return-Path: <linux-kernel-owner+w=401wt.eu-S1946399AbXBIMIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946399AbXBIMIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946402AbXBIMIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:08:12 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37964 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946399AbXBIMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:08:11 -0500
Message-ID: <45CC642A.4010803@vmware.com>
Date: Fri, 09 Feb 2007 04:08:10 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: virtualization@lists.osdl.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
References: <1171012296.2718.26.camel@localhost.localdomain> <1171018812.2718.66.camel@localhost.localdomain> <45CC5771.1070309@vmware.com> <200702091250.06482.ak@muc.de> <45CC60FD.6080606@vmware.com> <20070209115758.GA18080@muc.de>
In-Reply-To: <20070209115758.GA18080@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>>  
>>>       
>> My bad, I fell for the same mistake as everyone.  Set_fs is just way too 
>>     
>
> You could change the name. Only 654 occurrences all over the tree @)
>   

I'm preparing a patch.  +not.  This legacy thing is certainly taking a 
long time to disappear.  Long live x86!

>   
>> confusing of a name now.  But good to know interrupts must be disable in 
>> such a circumstance.
>>     
>
> +not
>   

+ack

Zach
