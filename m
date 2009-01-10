Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZAJSuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZAJSuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZAJSuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:50:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:38591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZAJSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T9dirgPZ5vAbE9zpPl5hUHlQh1gB3jrO5PWxBVEI1kdzqpPI2OcT1JDDmpJT3SgfAK
         3hhevfVrJTOPYoh54kUZzwk5kKtUQzYS2QW07aOnLGRZVq7meIpebZvwlhYMcy/rLKPe
         cSbwW3+kiRe6gd0wvyXvHGZHxD3NYI7/OpMCM=
Message-ID: <cabda6420901101049s5f7795fpf6ec033c95ba85ab@mail.gmail.com>
Date: Sat, 10 Jan 2009 19:49:58 +0100
From: "christian pellegrin" <chripell@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] MAX3100 SPI UART driver
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net, alan@lxorguk.ukuu.org.uk,
       device@lanana.org
In-Reply-To: <20090109142134.c388e699.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12229367533638-git-send-email-chripell@gmail.com>
	 <20090109142134.c388e699.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 11:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> afaik this patch is still stuck, awaiting a nod for this:
>
>> --- a/include/linux/serial_core.h
>> +++ b/include/linux/serial_core.h
>> @@ -155,6 +155,9 @@
>>
>>  #define PORT_SC26XX  82
>>
>> +/* MAX3100 */
>> +#define PORT_MAX3100    83
>> +
>

Hello,

I'm sorry. I asked two times following all the instructions in
devices.txt (or at least trying to do so) without any response. I hope
I didn't do something wrong. :-/

Thanks,

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
