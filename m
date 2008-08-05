Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbYHEPxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbYHEPxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbYHEPw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:52:58 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:36492 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbYHEPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:52:57 -0400
Message-ID: <56575.166.70.238.45.1217950327.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <200808060145.22321.nickpiggin@yahoo.com.au>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <200808060133.10457.nickpiggin@yahoo.com.au>
    <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
    <200808060145.22321.nickpiggin@yahoo.com.au>
Date: Tue, 5 Aug 2008 09:32:07 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: jmerkey@wolfmountaingroup.com, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 06 August 2008 01:19, jmerkey@wolfmountaingroup.com wrote:
>> > On Wednesday 06 August 2008 01:02, jmerkey@wolfmountaingroup.com
>> wrote:
>> >> > On Mon, 4 Aug 2008, jmerkey@wolfmountaingroup.com wrote:
>> >> >
>> >> > --
>> >> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>> >> > geert@linux-m68k.org
>> >>
>> >> No I was not, but I am now.  At any rate, I removed the
>> Microsoft-isms
>> >> from the code.  I can cut yet another patch for git6, but git5 was
>> there
>> >> -- GPL2 and all.  How about putting in into the kernel guys -- :-)
>> >
>> > Seriously? Because it doesn't seem to have had enough peer review,
>> > it hasn't had widespread testing in somewhere like linux-next or
>> > -mm, and we already have kgdb so you have to also explain why you
>> > can't improve kgdb in the areas it trails mdb.
>>
>> If you go back to LKML from 2000, this debugger has been around for 10
>> years.  I agree not in the hands of the public, but its very mature
>> in comparison to kdb or kgdb.
>
> OK I don't doubt that at all, but I just mean in terms of being reviewed
> by Linux people and how it merges with the current kernel (eg. we now
> have a debugger, which was unthinkable in 2000 :)).
>
>
>> > But the ideal outcome would be if you could contribute patches to
>> > kgdb to the point where it is as good as mdb. It is already in the
>> > tree and supported by a handful of architectures... any chance of
>> > that? (I don't know kernel debugger code, so I ask as an interested
>> > user)
>>
>> I plan to work on kdb and yes, there is a version of this that runs
>> as an alternate debugger of kdb - you can even switch back and forth
>> between them - but that misses the point as well.
>>
>> I can wait untl its more widespread -- or not.
>
> That would be great if you do work on kgdb... But I guess I do miss
> the point, then. Is there a technical difference with kgdb that cannot
> be worked around, a difference of opinion with maintainers, a wish to
> have mdb features at short notice?


Nick, its OK.  There have been 27,453 downloads of the patches from my ftp
server since yesterday when I osted it -- from what I am seeing people are
voting with their feet.   People can get it and I even posted it t
SourceForge as well.  After ten years of working on Linux I thougt it
would be nice for something I wrote to end up there.  It will happen when
its time.  As it stands, people are using it and it is going to help a lot
of folks, which is what this is all about.

:-)

Jeff
>


