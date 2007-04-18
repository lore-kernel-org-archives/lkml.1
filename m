Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbXDREwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbXDREwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXDREwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:52:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:59818 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbXDREwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=cyW/SO6/sACBZOmhNks9unPZ3QKwZzylkukOwpxlQo61kebsrNuIwdTavkqg0oRLqATULl0hK9WiA2ng5uRwJ3t9jAR+7wllbb0Tb+0jNM/F97QyRvuOkaLpeYb7ss+IZazktU4MjFjaSL8vORPEHuq09fi5fmqUk5qCy+384u0=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: floppy.ko
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Alain.Knaff@poboxes.com
References: <200704170036.00605.gene.heskett@verizon.net> <200704172312.49787.gene.heskett@gmail.com> <46259E18.6010003@zytor.com>
In-Reply-To: <46259E18.6010003@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 18 Apr 2007 00:52:08 -0400
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704180052.09259.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2007, H. Peter Anvin wrote:
>Gene Heskett wrote:
>> On Tuesday 17 April 2007, H. Peter Anvin wrote:
>>> Gene Heskett wrote:
>>>> I have the usual fd0, a 3.5" 1.44 drive, and fd1, a 5.25" 720k drive in
>>>> this machine, both are enabled in the bios with the correct types being
>>>> set there.
>>>
>>> A 5.25" 720k drive?!  That's not a PC standard drive -- 5.25" came in
>>> 180K, 360K and 1200K varieties, whereas 3.5" came in 720K, 1440K and
>>> 2880K varieties (not including superfloppies.)
>>>
>>> 	-hpa
>>
>> It sure is a std drive, Peter, although many of the later ones that were
>> set up as 1.2 megger's by the pc crowd who have access to a 500 kilobaud
>> controller, could have the 360 rpm spindle jumper'd back to 300 rpm, and
>> when fed with a 250 kilobaud controller (WD177x/277x/279x family, which
>> includes the Fujitsu MB8877), they are perfect 720k devices and are
>> spec'ed that way by the makers.  Many of the older full height Tandon
>> 100-4's could also step quite a few tracks closer to the spindle & I ran
>> them as 765k drives by using 84 tracks.  I even have a chinon that will
>> make 86 tracks most of the time.
>>
>> These were all quite common in the middle '80's.  Before your time I
>> suspect.
>
>I know they were quite common, but they were not a standard *PC*
>accessory.  (FWIW, 1200K PC drives could also read/write 720K, which
>allowed you to use non-HD-rated media.)
>
Chuckle, see how you are?  You keep quoting the 'PC', and 20 years ago the PC 
term included a lot of machinery that didn't always run M$ code.  TRS-80 
Color Computers and such, or Apple II, Commode-door etc.

>(And no, this wasn't "before my time".)

Figure of speech, Peter, considering that I could be the oldest subscriber to 
this list.  I've been around since '34.

>	-hpa

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Randal can write one-liners again.  Everyone is happy, and peace spreads
over the whole Earth.
             -- Larry Wall in <199705101952.MAA00756@wall.org>
