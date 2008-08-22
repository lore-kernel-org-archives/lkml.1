Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYHVVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYHVVUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYHVVUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:20:30 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:42045 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbYHVVU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:20:29 -0400
Message-ID: <48AF2D8E.9000405@cs.columbia.edu>
Date: Fri, 22 Aug 2008 17:20:14 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v2][PATCH 1/9] Create trivial sys_checkpoint/sys_restart
 syscalls
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>	 <Pine.LNX.4.64.0808202302510.17436@takamine.ncl.cs.columbia.edu> <1219433578.20559.98.camel@nimitz>
In-Reply-To: <1219433578.20559.98.camel@nimitz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Wed, 2008-08-20 at 23:03 -0400, Oren Laadan wrote:
>> 6/unistd_32.h
>> index d739467..88bdec4 100644
>> --- a/include/asm-x86/unistd_32.h
>> +++ b/include/asm-x86/unistd_32.h
>> @@ -338,6 +338,8 @@
>>   #define __NR_dup3             330
>>   #define __NR_pipe2            331
>>   #define __NR_inotify_init1    332
>> +#define __NR_checkpoint                333
>> +#define __NR_restart           334
>>
>>   #ifdef __KERNEL__
> 
> Uh oh.  These got whitespace mangled somehow.  I'll look through them,
> but probably can't produce patches on top of them for now.
> 

Oops .. not sure what happened.
I'll re-send after addressing the recent comments.

Oren.

