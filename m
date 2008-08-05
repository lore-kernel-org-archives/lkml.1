Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbYHERGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbYHERGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbYHERGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:06:07 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:60183 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbYHERGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:06:05 -0400
Message-ID: <1599.69.2.248.210.1217954713.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <200808060238.56113.nickpiggin@yahoo.com.au>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <200808060145.22321.nickpiggin@yahoo.com.au>
    <56575.166.70.238.45.1217950327.squirrel@webmail.wolfmountaingroup.com>
    <200808060238.56113.nickpiggin@yahoo.com.au>
Date: Tue, 5 Aug 2008 10:45:13 -0600 (MDT)
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

> On Wednesday 06 August 2008 01:32, jmerkey@wolfmountaingroup.com wrote:
>> > On Wednesday 06 August 2008 01:19, jmerkey@wolfmountaingroup.com
>> wrote:
>
>> > That would be great if you do work on kgdb... But I guess I do miss
>> > the point, then. Is there a technical difference with kgdb that cannot
>> > be worked around, a difference of opinion with maintainers, a wish to
>> > have mdb features at short notice?
>>
>> Nick, its OK.  There have been 27,453 downloads of the patches from my
>> ftp
>> server since yesterday when I osted it -- from what I am seeing people
>> are
>> voting with their feet.   People can get it and I even posted it t
>> SourceForge as well.  After ten years of working on Linux I thougt it
>> would be nice for something I wrote to end up there.  It will happen
>> when
>> its time.  As it stands, people are using it and it is going to help a
>> lot
>> of folks, which is what this is all about.
>>
>> :-)
>
> That's all well and good :). But it didn't exactly answer my question.
> My question was not what is the point of you writing these patches, but
> what is the point of merging it into the kernel (over the alternatives).
> It may seem like a trivial question, but it is one that must be answered
> in order to be considered to get merged.
>

Integrated kernel debugger in linux (minimal one) and given that there are
already patches to add tickets and text to locks and other tools, one more
can only help.    This is by no means the full MDB debugger you have seen,
just a pared down core I submitted.  The entire MDB debugger is much
larger.

I have been working on it for ten years, and you may or may not have
noticed, I typically do not ask many questions these days from the
community for my appliance and router development, nor ask for help for
any of the companies I have created and sold based on Linux over the past
ten years since I have tools to fix my stuff without needing a hardware
based inverse assembler like most folks need to debug hardware and file
systems on linux these days.

:-)

Jeff

Jeff

