Return-Path: <linux-kernel-owner+w=401wt.eu-S2992627AbXECPJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992627AbXECPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993189AbXECPJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:09:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:56201 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992627AbXECPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:09:55 -0400
Message-ID: <4639FBD6.6030907@oracle.com>
Date: Thu, 03 May 2007 08:12:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Bernhard Kaindl <bk@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/34] i386: fix mtrr sections
References: <20070430549.617098000@suse.de> <Pine.LNX.4.64.0705021559160.32650@jbgna.fhfr.qr> <Pine.LNX.4.64.0705031229300.27730@jbgna.fhfr.qr> <200705031319.34353.ak@suse.de>
In-Reply-To: <200705031319.34353.ak@suse.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> As Andy already submitted it to Linus with http://lkml.org/lkml/2007/5/2/346
>> we may have to create a patch which reverts this patch.
> 
> Ok thanks for the explanation. I will queue a revert patch
>  
>> I'm also planning to add some function headers to the MTRR functions
>> and also fix the existing and upcoming function headers to be complant
>> to kernel-doc.
> 
> Thanks
> 
> -Andi

Thanks from me also.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
