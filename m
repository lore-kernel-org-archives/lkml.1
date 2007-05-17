Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbXEQX5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbXEQX5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXEQX4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:56:53 -0400
Received: from alpha.lp.pl ([194.1.144.4]:49056 "EHLO alpha.polcom.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755450AbXEQX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:56:52 -0400
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 19:56:52 EDT
Date: Fri, 18 May 2007 01:31:46 +0200 (CEST)
From: Grzegorz Kulewski <kangur@polcom.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Further update of the i386 boot documentation
In-Reply-To: <464CE38B.8010802@zytor.com>
Message-ID: <Pine.LNX.4.63.0705180130010.14098@alpha.polcom.net>
References: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org>
 <464CE105.7030808@goop.org> <464CE38B.8010802@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, H. Peter Anvin wrote:
>>> +Field name:	kernel_version
>>> +Type:		read
>>> +Offset/size:	0x20e/2
>>> +Protocol:	2.00+
>>> +
>>> +  If set to a nonzero value, contains a pointer to a null-terminated
>>>
>>
>> "nil-terminated"? "\0-terminated"?
>
> Uh?  That seems more than a little silly.  Yes, I guess formally
> speaking we're talking about "NUL-terminated", but the term
> "null-terminated" has over 800,000 hits on Google -- 10 times as many as
> "NUL-terminated" -- and is hardly an ambiguous term ("NUL-terminated" is
> ugly, and "zero-terminated" is ambiguous.)

ASCIIZ?


Thanks,

Grzegorz Kulewski

