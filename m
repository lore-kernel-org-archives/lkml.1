Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZLUUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZLUUEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZLUUEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:04:32 -0500
Received: from mail.crca.org.au ([67.207.131.56]:40954 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbZLUUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:04:31 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B2FD4CC.5070609@crca.org.au>
Date: Tue, 22 Dec 2009 07:04:28 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
References: <200912210140.19713.rjw@sisk.pl>  <4B2F22EF.6040500@crca.org.au> <1261425499.4328.10.camel@maxim-laptop>
In-Reply-To: <1261425499.4328.10.camel@maxim-laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Maxim Levitsky wrote:
> On Mon, 2009-12-21 at 18:25 +1100, Nigel Cunningham wrote: 
>> Hi.
>>
>> Rafael J. Wysocki wrote:
>>> I'm not sure what the next step should be at this point.  To me, the picture is
>>> quite clear now, but perhaps we ought to run more tests on some other machines
>>> or something.  Please let me know what you think.
>> Looks great. If you do decide you want other machines tested, I'll
>> happily try the machines around here:
>>
>> - Dell M1530
>> - Omnibook XE3-GF.
>> - Via LN10000 based Mythtv Box
>> - Desktop machine - Some Intel-based mobo I've forgotten the name of.
>>
>> I've been quietly following the thread, but have lost track of what
>> iteration of the patch you're on, so if you'd give me a pointer to it,
>> I'd be grateful.
>>
>> By the way, I haven't forgotten about sending some real patches for
>> swsusp (ie more than just cleanups). I'm just busy with other things and
>> also thinking carefully about what order to do things in.
> 
> I vote for ability to save all ram to the disk.
> After several days of testing I managed to make my system do s2disk
> really reliable (~300 cycles tested), but suspending when memory is
> tight still fails sometimes.
> 
> I didn't yet use your tuxonice system  though.

Well, I want to and intend on working towards merging as much of
TuxOnIce as people will allow in, but it will take a long time because
there are so many modifications to do, I don't have that much time to
work on it, am splitting the time I do have and am still have a couple
of new features I want to do to TuxOnIce.

Regards,

Nigel
