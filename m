Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZABKEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZABKEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZABKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:03:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:14142 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbZABKDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:03:55 -0500
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Message-Id: <45153060-F5A5-44BE-B2A0-C995E65ACE9C@mirell.org>
From: Mark Miller <mark@mirell.org>
To: Mark Miller <mark@mirell.org>
In-Reply-To: <8A892FD3-50DE-4AFF-A314-5BB3284644EC@mirell.org>
Content-Type: text/plain; charset=UTF-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 2 Jan 2009 04:03:47 -0600
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <8A892FD3-50DE-4AFF-A314-5BB3284644EC@mirell.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 2, 2009, at 4:02 AM, Mark Miller wrote:

>
> On Jan 2, 2009, at 3:26 AM, Arkadiusz Miskiewicz wrote:
>
>> On Friday 02 of January 2009, Rob Landley wrote:
>>> Before 2.6.25 (specifically git  
>>> bdc807871d58285737d50dc6163d0feb72cb0dc2 )
>>> building a Linux kernel never required perl to be installed on the  
>>> build
>>> system.  (Various development and debugging scripts were written  
>>> in perl
>>> and python and such, but they weren't involved in actually  
>>> building a
>>> kernel.) Building a kernel before 2.6.25 could be done with a  
>>> minimal
>>> system built from gcc, binutils, bash, make, busybox, uClibc, and  
>>> the Linux
>>> kernel, and nothing else.
>>
>> And now bash is going to be required... while some distros don't  
>> need/have
>> bash. /bin/sh should be enough.
>
> Which distros only have /bin/sh which do not have Perl? I'm honestly  
> curious.

That is, *do* have Perl. Typo there.

>
>
>> -- 
>> Arkadiusz Miśkiewicz        PLD/Linux Team
>> arekm / maven.pl            http://ftp.pld-linux.org/

--
Mark Miller
mark@mirell.org




