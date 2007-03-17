Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbXCQLsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbXCQLsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 07:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXCQLsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 07:48:11 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:58401 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXCQLsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 07:48:10 -0400
Date: Sat, 17 Mar 2007 07:48:08 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL v0.31
In-reply-to: <1174115517.7911.66.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Nicholas Miell <nmiell@comcast.net>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200703170748.08495.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
 <1174112768.3144.8.camel@entropy> <1174115517.7911.66.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007, Mike Galbraith wrote:
>On Fri, 2007-03-16 at 23:26 -0700, Nicholas Miell wrote:
>> RSDL appears to be completely deterministic, which is a very strong
>> virtue.
>
>Yes.  That's why RSDL aroused my curiosity big time.
>
>> The X people have plans for how to go about fixing this, but until
>> then, there's no reason to hold up kernel development.
>
>I'm not in a position to hold up development.
>
>On a side note, I wonder how long it's going to take to fix all the
>X/client combinations out there.

And on yet another side note Mike, I just did a make -j8 for all make 
options in my makeit script, something I don't normally do, and while 
running 2.6.20.3-rdsl-0.31, building 2.6.21-rc4, the machine remained 
100% responsive, worst case keyboard lag that I observed might have been 
200 or 300 milliseconds.  The machine remained usable, which to me is the 
bottom line.  And no, I wasn't running xmms at the time or watching 
tvtime else I'd have awakened the missus.

I'm having a hard time justifying your continual fussing as its obviously 
a huge improvement to me.  What makes your system and loading so much 
different from mine I wonder...

In the meantime I'm a very happy camper about this patch.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I prefer rogues to imbeciles because they sometimes take a rest.
		-- Alexandre Dumas, fils
