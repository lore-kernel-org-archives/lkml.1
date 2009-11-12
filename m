Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZKLRw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZKLRw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZKLRw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:52:27 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46257 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZKLRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:52:26 -0500
Message-ID: <4AFC4B56.7020908@cs.helsinki.fi>
Date: Thu, 12 Nov 2009 19:52:22 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [PATCH] MAINTAINERS: KMEMTRACE - Add file patterns, correct Pekka's
 entry to single line M:
References: <1258047606.1988.15.camel@Joe-Laptop.home> <20091112175056.GA20542@elte.hu>
In-Reply-To: <20091112175056.GA20542@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 8264e6b..b7dbdd9 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3086,9 +3086,13 @@ F:	kernel/kgdb.c
>>  
>>  KMEMCHECK
>>  M:	Vegard Nossum <vegardno@ifi.uio.no>
>> -P	Pekka Enberg
>> -M:	penberg@cs.helsinki.fi
>> +M:	Pekka Enberg <penberg@cs.helsinki.fi>
>>  S:	Maintained
>> +F:	Documentation/kmemcheck.txt
>> +F:	arch/x86/include/asm/kmemcheck.h
>> +F:	arch/x86/mm/kmemcheck/
>> +F:	include/linux/kmemcheck.h
>> +F:	mm/kmemcheck.c
> 
> Note, subject says kmemtrace - while this is about kmemcheck.

Yup. Vegard, do you want Joe to resend or are you going to fix it up 
when applying?

			Pekka
