Return-Path: <linux-kernel-owner+w=401wt.eu-S1767142AbXCIKbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767142AbXCIKbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993106AbXCIKbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:31:48 -0500
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:55926 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993105AbXCIKbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:31:47 -0500
Message-ID: <45F13791.8040408@gmail.com>
Date: Fri, 09 Mar 2007 11:31:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>	<45E996A0.6070700@gmail.com>	<45E99A45.9030506@gmail.com> <20070303094125.838ce04d.akpm@linux-foundation.org>
In-Reply-To: <20070303094125.838ce04d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Sat, 03 Mar 2007 16:54:45 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>>
>> Jiri Slaby napsal(a):
>>> Andrew Morton napsal(a):
>>>> Temporarily at
>>>>
>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
>>> Weird behaviour of numlock and capslock on USB keyboard in X. After 
>> Hmm, it's not X related. Console behaves similarly.
>>
>>> pressing
>> Or actually if some script tries to change LEDs (logout).
>>
>>> those keys, keyboard "hangs" -- no sysrq, no lock leds are flashing.
>>>
>>> After plug; unplug of the keyboard, it works unless I press the keys
>>> again.
>>>
>>> There is nothing in dmesg. X log says
>>> (II) evdev brain: Rescanning devices (3).
>>> (II) evdev brain: Rescanning devices (4).
>>> (II) evdev brain: Rescanning devices (5).
>>> (II) evdev brain: Rescanning devices (6).
>>> (II) evdev brain: Rescanning devices (7).
>>> (II) evdev brain: Rescanning devices (8).
>>> (II) evdev brain: Rescanning devices (9).
>>> (II) evdev brain: Rescanning devices (10).
>>> (II) evdev brain: Rescanning devices (11).
>>> (II) evdev brain: Rescanning devices (12).
>>> (II) evdev brain: Rescanning devices (13).
>>> (II) evdev brain: Rescanning devices (14).
>>> in this kernel, but I don't know if this is relevant.
>>>
>>> After booting back to .20-mm2 everything is OK.
> 
> Thanks.  Cc's added.

Remains unsolved in 2.6.21-rc3-mm2.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
